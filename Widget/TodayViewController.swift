//
//  TodayViewController.swift
//  Widget
//
//  Created by Hykilpikonna on 10/23/20.
//

import UIKit
import NotificationCenter

// Time - Such as 8:20
struct Time {
    let hour: Int
    let minutes: Int
}

class TodayViewController: UIViewController, NCWidgetProviding
{
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        label.text = UserDefaults(suiteName: "group.org.hydev.zoomlink")!.string(forKey: "calendar-url")
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        completionHandler(NCUpdateResult.newData)
    }
}
