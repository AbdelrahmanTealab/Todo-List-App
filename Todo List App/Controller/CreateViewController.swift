//
//  CreateViewController.swift
//  Todo List App
//
//  Created by Abdelrahman  Tealab on 2020-11-29.
//  Student ID: 301164103

import UIKit
import Firebase

class CreateViewController: UIViewController {
    //outlets
    @IBOutlet weak var todoName: UITextField!
    @IBOutlet weak var todoNotes: UITextView!
    @IBOutlet weak var todoDatePicker: UIDatePicker!
    @IBOutlet weak var hasDueDate: UISwitch!
    //formatter and db
    let formatter = DateFormatter()
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func hasDueDateSwitched(_ sender: UISwitch) {
        //disabling and enabling date picker when due date is switched on or off
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
        //when create is pressed, i make sure that name and notes arent empty then proceed
        if todoName.text!.isEmpty || todoNotes.text.isEmpty {
            let alert = UIAlertController(title: "Missing Info", message: "Please fill in the Name and Notes for your Todo !", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        else{
            // i assign the fields to variables then format the date given from the date picker
            // in a nice readable format
            let name = todoName.text!
            let notes = todoNotes.text!
            var dueDate = ""
            if hasDueDate.isOn {
                formatter.dateFormat = K.dateFormat
                formatter.dateStyle = .medium
                formatter.timeStyle = .short
                dueDate = formatter.string(from: todoDatePicker.date)
            }
            //then i store the todo into the firebase db
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
            //when its done it dismisses itself like a good boi
            self.dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func cancelPressed(_ sender: UIButton) {
        //pressing cancel will show a pop up to confirm cancelation
            let alert = UIAlertController(title: "Cancel ?", message: "Are you sure you want to cancel ?", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "YES", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
                self.dismiss(animated: true, completion: nil)
                }))
            alert.addAction(UIAlertAction(title: "NO", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)

        }
}
