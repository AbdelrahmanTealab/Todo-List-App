//
//  DetailsViewController.swift
//  Todo List App
//
//  Created by Abdelrahman  Tealab on 2020-11-14.
//  Student ID: 301164103

import UIKit
import Firebase

class DetailsViewController: UIViewController {
    //outlets
    @IBOutlet weak var todoName: UITextField!
    @IBOutlet weak var todoDate: UIDatePicker!
    @IBOutlet weak var todoHasDue: UISwitch!
    @IBOutlet weak var todoNotes: UITextView!
    @IBOutlet weak var todoComplete: UISwitch!
    //variables recieved from ViewController
    var name:String?
    var duedate:String?
    var notes:String?
    var completed:Bool?
    //firebase db and date formatter
    let db = Firestore.firestore()
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //assigning data from ViewController to current screen
        todoName.text = name ?? ""
        todoNotes.text = notes ?? ""
        todoComplete.isOn = completed ?? false
        
        //checking if the date picker should be enabled or not
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
    //disable date picker when turning off due date
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
    //MARK: - UPDATE
    //update function
    @IBAction func updatePressed(_ sender: UIButton) {
        //alert to make sure the user didnt leave name or notes empty
        if todoName.text!.isEmpty || todoNotes.text.isEmpty {
            let alert = UIAlertController(title: "Missing Info", message: "Please fill in the Name and Notes for your Todo !", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            let changedName = todoName.text!
            //by comparing the given data from previous controller, if given a new name then i'll have to make a new document in the firebase db and delete the old one thats why i have to check if the name is changed
            if changedName != name{
                db.collection(K.collectionName).document(name!).delete() { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        print("Document successfully removed!")
                    }
                }
            }
            //other i will store the new data into the document's given name eitherways
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
        //then i dismiss the modal view
        self.dismiss(animated: true, completion: nil)
    }
    //MARK: - DELETE
    //delete function
    func deleteFunction() {
        //this function will be called when the user is sure to delete as shown below
        db.collection(K.collectionName).document(name!).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    //when delete button is pressed
    @IBAction func deletePressed(_ sender: UIButton) {
        //an alert will pop up to asure the user of their decision
        let alert = UIAlertController(title: "Hold up!", message: "Are you sure you want to delete this todo ?", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "YES", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
            //if yes, i call the function delete
            self.deleteFunction()
            }))
        alert.addAction(UIAlertAction(title: "NO", style: UIAlertAction.Style.default, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }
    //MARK: - CANCEL
    //cancel function
    @IBAction func cancelPressed(_ sender: UIButton) {
        //pressing cancel will show a pop up only if one of the fields are changed otherwise it'll dismiss without a question
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

