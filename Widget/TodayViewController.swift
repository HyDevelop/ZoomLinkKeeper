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
}

class TodayViewController: UIViewController, NCWidgetProviding
{
    let prefs = UserDefaults(suiteName: "group.org.hydev.zoomlink")!
    
    @IBOutlet weak var label: UILabel!
    
    let periodTimes = [Time(8,20), Time(9,30), Time(10,35), Time(12,29), Time(13,34)]
    
    /// Today's date and day in the schedule rotation
    var todaysDate: String = ""
    var day: Int = 0
    var blocks: [String] = []
    
    /// Initialize
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    /// Perform any setup necessary in order to update the view.
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void))
    {
        // If the day haven't updated in a day yet
        if (todaysDate != getTodayDate())
        {
            getHttp()
        }
        else
        {
            update()
        }
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        completionHandler(NCUpdateResult.newData)
    }
    
    /// Update within a day
    func update()
    {
        label.text = "Today is day " + String(day) + " (" + blocks.joined(separator: "") + ")";
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
            let match = regex.firstMatch(in: html, options: [], range: NSRange(location: 0, length: html.utf16.count))!
           
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
