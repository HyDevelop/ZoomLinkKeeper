//
//  LinksViewController.swift
//  ZoomLinkKeeper
//
//  Created by Hykilpikonna on 10/23/20.
//

import UIKit

class LinksViewController: UIViewController
{
    @IBOutlet var table: UITableView!
    @IBOutlet var dataSource: UITableViewDataSource!
    
    @IBOutlet weak var lightButton: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Initialize table
        dataSource = MyDataSource()
        table.dataSource = dataSource
        
        // Initialize light button
        if traitCollection.userInterfaceStyle == .dark
        {
            // User Interface is Dark
            lightButton.setTitle("Light On", for: .normal)
        }
        else
        {
            // User Interface is Light
            lightButton.setTitle("Light Off", for: .normal)
        }
    }
    
    /// Since the iOS programming class has a "flashlight" project for unit 1,
    /// I'll just randomly add this button here xD
    @IBAction func lights(_ sender: Any)
    {
        if traitCollection.userInterfaceStyle == .dark
        {
            view.window?.overrideUserInterfaceStyle = .light
            lightButton.setTitle("Light Off", for: .normal)
        }
        else
        {
            view.window?.overrideUserInterfaceStyle = .dark
            lightButton.setTitle("Light On", for: .normal)
        }
    }
    
    class MyDataSource: NSObject, UITableViewDataSource
    {
        /// How many items are in the table
        func tableView(_ v: UITableView, numberOfRowsInSection rows: Int) -> Int
        {
            return 7
        }
        
        func tableView(_ v: UITableView, cellForRowAt i: IndexPath) -> UITableViewCell
        {
            guard let cell = v.dequeueReusableCell(withIdentifier: "blockLinkConfig", for: i) as? LinkTableCell
            else {
                fatalError("The dequeued cell is not an instance of LinkTableCell.")
            }
            
            cell.label.text = String(Character(UnicodeScalar(i.item + 65)!)) + " Block"
            
            // Read config
            if let url = MyConstants.prefs.string(forKey: cell.label.text!)
            {
                cell.input.text = url
            }
            
            return cell;
        }
    }
}
