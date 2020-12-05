//
//  ListCell.swift
//  Todo List App
//
//  Created by Abdelrahman  Tealab on 2020-11-14.
//  Student ID: 301164103

import UIKit

class ListCell: UITableViewCell {
    
    @IBOutlet weak var listBackground: UIView!
    @IBOutlet weak var listTitle: UILabel!
    @IBOutlet weak var listDate: UILabel!

        
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //ibaction for the edit button and switch button for later
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
