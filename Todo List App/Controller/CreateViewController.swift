//
//  CreateViewController.swift
//  Todo List App
//
//  Created by Abdelrahman  Tealab on 2020-11-29.
//

import UIKit
import Firebase

class CreateViewController: UIViewController {
    
    @IBOutlet weak var todoName: UITextField!
    @IBOutlet weak var todoNotes: UITextView!
    @IBOutlet weak var todoDatePicker: UIDatePicker!
    @IBOutlet weak var hasDueDate: UISwitch!
    let formatter = DateFormatter()
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func hasDueDateSwitched(_ sender: UISwitch) {
        if hasDueDate.isOn == true {
            todoDatePicker.alpha = 1
            todoDatePicker.isUserInteractionEnabled = true
        }
        else{
            todoDatePicker.alpha = 0.2
            todoDatePicker.isUserInteractionEnabled = false
        }
    }
    
    @IBAction func createPressed(_ sender: UIButton) {
        if todoName.text!.isEmpty || todoNotes.text.isEmpty {
            let alert = UIAlertController(title: "Missing Info", message: "Please fill in the Name and Notes for your Todo !", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        else{
            let name = todoName.text!
            let notes = todoNotes.text!
            var dueDate = ""
            if hasDueDate.isOn {
                formatter.dateFormat = K.dateFormat
                formatter.dateStyle = .medium
                formatter.timeStyle = .short
                dueDate = formatter.string(from: todoDatePicker.date)
            }
            db.collection(K.collectionName).document(name).setData([
                "name":name,
                "notes":notes,
                "duedate":dueDate,
                "iscompleted":false
            ]){(error) in
                if let e = error{
                    print("error saving data: \(e)")
                }
                else{
                    print("data saved successfully")
                }
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func cancelPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}
