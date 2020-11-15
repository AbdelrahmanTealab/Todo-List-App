//
//  ListCell.swift
//  Todo List App
//
//  Created by Abdelrahman  Tealab on 2020-11-14.
//  Student ID: 301164103

import UIKit
// this protocol is to be able to press the button that is inside the cell and execute its function
protocol ListCellDelegate:AnyObject{
    func completionSwitched()
    
    func editPressed(_ sender: UIButton)
}

class ListCell: UITableViewCell {
    weak var delegate: ListCellDelegate?
    
    @IBOutlet weak var listBackground: UIView!
    @IBOutlet weak var listTitle: UILabel!
    @IBOutlet weak var listDate: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var switchButton: UISwitch!
        
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //ibaction for the edit button and switch button for later
    @IBAction func completionSwitched(_ sender: UISwitch) {
        delegate?.completionSwitched()
    }
    @IBAction func editPressed(_ sender: UIButton) {
        delegate?.editPressed(sender)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
