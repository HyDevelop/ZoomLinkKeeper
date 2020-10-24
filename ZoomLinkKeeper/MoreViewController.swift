//
//  ViewController.swift
//  ZoomLinkKeeper
//
//  Created by Hykilpikonna on 10/22/20.
//

import UIKit

class MoreViewController: UIViewController
{
    @IBOutlet weak var calendarUrl: UITextField!
    @IBOutlet weak var regex: UITextField!
    
    /**
     * View loaded (setup)
     */
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Load settings
        calendarUrl.text = MyConstants.prefs.string(forKey: "calendar-url");
        regex.text       = MyConstants.prefs.string(forKey: "regex");
    }
    
    /// Save settings
    @IBAction func saveSettings(_ sender: Any)
    {
        MyConstants.prefs.setValue(calendarUrl.text, forKey: "calendar-url")
        MyConstants.prefs.setValue(regex.text, forKey: "regex")
    }
    
    /// Reset data fields
    @IBAction func resetCalendarUrl(_ sender: Any)
    {
        calendarUrl.text = MyConstants.defaultCalendarUrl
        saveSettings(sender)
    }
    @IBAction func resetRegex(_ sender: Any)
    {
        regex.text = MyConstants.defaultRegex
        saveSettings(sender)
    }
}
