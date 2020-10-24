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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Initialize table
        dataSource = MyDataSource()
        table.dataSource = dataSource
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
