//
//  ListCell.swift
//  Todo List App
//
//  Created by Abdelrahman  Tealab on 2020-11-14.
//

import UIKit

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
        // Initialization code
    }
    
    @IBAction func completionSwitched(_ sender: UISwitch) {
        delegate?.completionSwitched()
    }
    @IBAction func editPressed(_ sender: UIButton) {
        delegate?.editPressed(sender)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
