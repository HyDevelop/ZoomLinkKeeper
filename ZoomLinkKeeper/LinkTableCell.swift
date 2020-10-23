//
//  LinkTableCell.swift
//  ZoomLinkKeeper
//
//  Created by Hykilpikonna on 10/23/20.
//

import UIKit

class LinkTableCell: UITableViewCell
{
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var input: UITextField!
    
    @IBAction func saveInput(_ sender: Any)
    {
        UserDefaults(suiteName: "org.hydev.ZoomLinkKeeper")!.setValue(input.text, forKey: label.text!)
    }
}
