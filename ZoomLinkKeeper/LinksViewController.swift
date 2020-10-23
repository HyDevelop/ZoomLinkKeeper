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
    class MyDataSource: NSObject, UITableViewDataSource
    {
        /// How many items are in the table
        func tableView(_ v: UITableView, numberOfRowsInSection rows: Int) -> Int
        {
            return 7
        }
        
        func tableView(_ v: UITableView, cellForRowAt i: IndexPath) -> UITableViewCell
        {
            
        }
    }
}
