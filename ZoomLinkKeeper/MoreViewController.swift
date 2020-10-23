//
//  ViewController.swift
//  ZoomLinkKeeper
//
//  Created by Hykilpikonna on 10/22/20.
//

import UIKit

class MoreViewController: UIViewController
{
    let userDefaults = UserDefaults.standard
    
    @IBOutlet weak var calendarUrl: UITextField!
    @IBOutlet weak var regex: UITextField!
    
    /**
     * View loaded (setup)
     */
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Load settings
        calendarUrl.text = userDefaults.string(forKey: "calendar-url");
        regex.text       = userDefaults.string(forKey: "regex");
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
