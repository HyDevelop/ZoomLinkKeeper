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
}

class TodayViewController: UIViewController, NCWidgetProviding
{
    let prefs = UserDefaults(suiteName: "group.org.hydev.zoomlink")!
    
    @IBOutlet weak var label: UILabel!
    
    let periodTimes = [Time(8,20), Time(9,30), Time(10,35), Time(12,29), Time(13,34)]
    
    /// Today's date and day in the schedule rotation
    var todaysDate: String = ""
    var day: Int = 0
    
    /// Initialize
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    /// Update
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void))
    {
        // Perform any setup necessary in order to update the view.
        
        label.text = prefs.string(forKey: "calendar-url")
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        completionHandler(NCUpdateResult.newData)
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
        let url = URL(string: prefs.string(forKey: "calendar-url")!)!
        let regex = try! NSRegularExpression(pattern: prefs.string(forKey: "regex")!)
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // Valid data
            guard let data = data else { return }
            let html = String(data: data, encoding: .utf8)!
            
            // Match regex through all characters
            let match = regex.firstMatch(in: html, options: [], range: NSRange(location: 0, length: html.utf16.count))!
           
            // Update the variables
            self.todaysDate = self.getTodayDate();
            self.day = Int(html[Range(match.range, in: html)!])! // TODO: Handle errors
        }
        
        // Actually start the call
        task.resume()
    }
}
