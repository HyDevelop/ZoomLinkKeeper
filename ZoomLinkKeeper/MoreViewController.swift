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
}
