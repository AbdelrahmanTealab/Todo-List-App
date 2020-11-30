//
//  DetailsViewController.swift
//  Todo List App
//
//  Created by Abdelrahman  Tealab on 2020-11-14.
//  Student ID: 301164103

import UIKit
import Firebase

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var todoName: UITextField!
    @IBOutlet weak var todoDate: UIDatePicker!
    @IBOutlet weak var todoHasDue: UISwitch!
    @IBOutlet weak var todoNotes: UITextView!
    @IBOutlet weak var todoComplete: UISwitch!
    
    var name:String?
    var duedate:String?
    var notes:String?
    var completed:Bool?
    
    let db = Firestore.firestore()
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        todoName.text = name ?? ""
        todoNotes.text = notes ?? ""
        todoComplete.isOn = completed ?? false
        
        if duedate != "" {
            todoHasDue.isOn = true
        }
        else
        {
            todoHasDue.isOn = false
        }
        
        if todoHasDue.isOn == true {
            todoDate.alpha = 1
            todoDate.isUserInteractionEnabled = true
        }
        else{
            todoDate.alpha = 0.2
            todoDate.isUserInteractionEnabled = false
        }
    }
    @IBAction func dueDateSwitched(_ sender: UISwitch) {
        if todoHasDue.isOn == true {
            todoDate.alpha = 1
            todoDate.isUserInteractionEnabled = true
        }
        else{
            todoDate.alpha = 0.2
            todoDate.isUserInteractionEnabled = false
        }
    }
    
    @IBAction func updatePressed(_ sender: UIButton) {
        if todoName.text!.isEmpty || todoNotes.text.isEmpty {
            let alert = UIAlertController(title: "Missing Info", message: "Please fill in the Name and Notes for your Todo !", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            let changedName = todoName.text!
            
            if changedName != name{
                db.collection(K.collectionName).document(name!).delete() { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        print("Document successfully removed!")
                    }
                }
            }
            
            let changedNotes = todoNotes.text!
            var changedDueDate = ""
            let isCompleted = todoComplete.isOn
            if todoHasDue.isOn {
                formatter.dateFormat = K.dateFormat
                formatter.dateStyle = .medium
                formatter.timeStyle = .short
                changedDueDate = formatter.string(from: todoDate.date)
            }
            db.collection(K.collectionName).document(changedName).setData([
                "name":changedName,
                "notes":changedNotes,
                "duedate":changedDueDate,
                "iscompleted":isCompleted
            ]){(error) in
                if let e = error{
                    print("error saving data: \(e)")
                }
                else{
                    print("data saved successfully")
                }
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func deleteFunction() {
        db.collection(K.collectionName).document(name!).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deletePressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Hold up!", message: "Are you sure you want to delete this todo ?", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "YES", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
            self.deleteFunction()
            }))
        alert.addAction(UIAlertAction(title: "NO", style: UIAlertAction.Style.default, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func cancelPressed(_ sender: UIButton) {
        if name! != todoName.text! || notes! != todoNotes.text! || completed! != todoComplete.isOn{
            let alert = UIAlertController(title: "Wait a second!", message: "you have some unsaved changes, are you sure you want to cancel ?", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "YES", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
                self.dismiss(animated: true, completion: nil)
                }))
            alert.addAction(UIAlertAction(title: "NO", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)

        }
        else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}

