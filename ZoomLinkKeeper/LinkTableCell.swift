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
        save()
    }
    
    /// Paste text (the method name "paste" conflicts with ObjectiveC's paste:)
    @IBAction func pasta(_ sender: Any)
    {
        if let clip = UIPasteboard.general.string
        {
            input.text = clip
            save()
        }
    }
    
    func save()
    {
        MyConstants.prefs.setValue(input.text, forKey: label.text!)
    }
}
