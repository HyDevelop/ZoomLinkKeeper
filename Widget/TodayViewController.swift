//
//  TodayViewController.swift
//  Widget
//
//  Created by Hykilpikonna on 10/23/20.
//

import UIKit
import NotificationCenter

// Time - Such as 8:20
class Time
{
    let hour: Int
    let minutes: Int
    
    init(_ h: Int, _ m: Int)
    {
        hour = h
        minutes = m
    }
    
    init()
    {
        hour = Calendar.current.component(.hour, from: Date())
        minutes = Calendar.current.component(.minute, from: Date())
    }
    
    static func >(a: Time, b: Time) -> Bool
    {
        return a.hour > b.hour || (a.hour == b.hour && a.minutes > b.minutes)
    }
    
    public var description: String
    {
        return String(hour) + ":" + String(minutes)
    }
}

class TodayViewController: UIViewController, NCWidgetProviding
{
    let prefs = UserDefaults(suiteName: "group.org.hydev.zoomlink")!
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var currentBlockLabel: UILabel!
    @IBOutlet weak var nextBlockLabel: UILabel!
    @IBOutlet weak var currentBlockTime: UILabel!
    @IBOutlet weak var nextBlockTime: UILabel!
    @IBOutlet weak var currentBlockButton: UIButton!
    @IBOutlet weak var nextBlockButton: UIButton!
    
    let periodTimes = [Time(8,20), Time(9,30), Time(10,35), Time(12,29), Time(13,34)]
    let endTimes = [Time(9,20), Time(10,25), Time(12,19), Time(13,24), Time(14,29)]
    
    /// Today's date and day in the schedule rotation
    var todaysDate: String = ""
    var day: Int = 0
    var blocks: [String] = []
    
    /// Updated on widgetPerformUpdate()
    var currentPeriod: Int = 0
    
    /// Initialize
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    /// Open zoom links
    @IBAction func currentBlockClick(_ sender: Any) { openUrl(currentPeriod) }
    @IBAction func nextBlockClick(_ sender: Any) { openUrl(currentPeriod + 1) }
    
    /// Open the zoom link for a period
    func openUrl(_ period: Int)
    {
        // Get link
        guard let link = prefs.string(forKey: blocks[period] + " Block") else
        {
            label.text = "Please setup in the app first :("
            return
        }
        
        // To url
        guard let url = URL(string: link) else
        {
            label.text = "URL for " + blocks[period] + " failed to parse :("
            return
        }
        
        // Open url
        extensionContext?.open(url)
    }
    
    /// Perform any setup necessary in order to update the view.
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void))
    {
        // If the day haven't updated in a day yet
        if (todaysDate != getTodayDate()) { getHttp() }
        else { update() }
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        completionHandler(NCUpdateResult.newData)
    }
    
    /// Update within a day
    func update()
    {
        // Update title text
        label.text = "Day " + String(day) + " (" + blocks.joined(separator: "") + ")";
        
        // Find current block index
        let time = Time()
        var period = -1
        for i in stride(from: 4, through: 0, by: -1)
        {
            if (time > periodTimes[i]) { period = i; break }
        }
        currentPeriod = period
        
        // Function: change one item to a block
        func assignBlock(_ current: Bool, _ prefix: String)
        {
            setText(current, prefix + blocks[period], periodTimes[period].description + " - " + endTimes[period].description, true)
        }
        
        // Day haven't started yet
        if (period == -1) { setText(true, "Breakfast?", "-", false) }
        else { assignBlock(true, "Current Block: ") }
        
        if (period == 4) { setText(false, "School Ended", "-", false) }
        else { assignBlock(false, "Next Block: ") }
    }
    
    /// Set item text
    func setText(_ current: Bool, _ label: String, _ time: String, _ buttonEnabled: Bool)
    {
        if (current)
        {
            currentBlockLabel.text = label
            currentBlockTime.text = time
            currentBlockButton.isEnabled = buttonEnabled
        }
        else
        {
            nextBlockLabel.text = label
            nextBlockTime.text = time
            nextBlockButton.isEnabled = buttonEnabled
        }
    }
    
    /// Get the string of today's date
    func getTodayDate() -> String
    {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f.string(from: Date())
    }
    
    /// Get today's schedule rotation day from Http
    func getHttp()
    {
        let urlString = prefs.string(forKey: "calendar-url")!
        let url = URL(string: urlString)!
        let regex = try! NSRegularExpression(pattern: prefs.string(forKey: "regex")!)
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // Validate data
            guard error == nil else { return }
            guard let data = data else { return }
            let html = String(data: data, encoding: .utf8)!
            
            // Match regex through all characters
            guard let match = regex.firstMatch(in: html, options: [], range: NSRange(location: 0, length: html.utf16.count)) else
            {
                // No match, possibly it's a day off
                DispatchQueue.main.async
                {
                    self.label.text = "404, might be a day off?"
                }
                return
            }
           
            // Update the variables
            self.todaysDate = self.getTodayDate();
            self.day = Int(html[Range(match.range, in: html)!])! // TODO: Handle errors
            
            // Calculate blocks
            let start = (self.day - 1) * 5 % 7
            self.blocks = []
            for i in 0...4
            {
                self.blocks.append(String(Character(UnicodeScalar(start + i + 65)!)))
            }
            
            // Sync thread. This literally took me an hour to debug ;-;
            DispatchQueue.main.async
            {
                // Update view
                self.update()
            }
        }
        
        // Actually start the call
        task.resume()
    }
}
