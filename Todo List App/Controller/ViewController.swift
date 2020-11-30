//
//  ViewController.swift
//  Todo List App
//
//  Created by Abdelrahman  Tealab on 2020-11-13.
//  Student ID: 301164103

import UIKit
import Firebase

class ViewController: UIViewController {
    let db = Firestore.firestore()

    @IBOutlet weak var listTableView: UITableView!

    //a list of random data to test my UX/UI
    var lists:[List] = [
        List(name: "Grocery", dueDate: Date().description, notes: "banana,apple,orange",isCompleted:false),
        List(name: "Games", dueDate: Date().description, notes: "Red Dead,Cyberpunk,Tekken",isCompleted:false),
        List(name: "Productivity", dueDate: Date().description, notes: "Finish app UI,Study iOS,Study UIUX",isCompleted:true),
        List(name: "Music", dueDate: Date().description, notes: "Her Mannelig,In The Air Tonight,Unshaken",isCompleted:true)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        listTableView.dataSource=self
        listTableView.delegate=self
        //registering my custom cell name
        listTableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        loadTodos()
    }
    
    func loadTodos(){

        db.collection(K.collectionName)
            .addSnapshotListener{ (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    self.lists = []
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        if let todoName = data["name"] as? String,let todoNotes = data["notes"] as? String,let todoDate = data["duedate"] as? String,let todoComplete = data["iscompleted"] as? Bool{
                            let newList = List(name: todoName, dueDate: todoDate, notes: todoNotes, isCompleted: todoComplete)
                            self.lists.append(newList)
                            DispatchQueue.main.async {
                                self.listTableView.reloadData()
                            }
                        }
                    }
                }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == K.segueName) {
            let destinationVC = (segue.destination as! DetailsViewController)
            destinationVC.name = (sender as! List).name
            destinationVC.notes = (sender as! List).notes
            destinationVC.duedate = (sender as! List).dueDate
            destinationVC.completed = (sender as! List).isCompleted
        }
    }
}
//Extensions
    //MARK: - Table data source
extension ViewController:UITableViewDataSource{
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //returning the number of items in the list to display it as the number of rows
        return lists.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //setting my cell as ListCell as this is my custom cell
        let cell = listTableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! ListCell
        //setting the title and dates of the custom cell
        cell.listTitle?.text = lists[indexPath.row].name
        cell.listDate?.text = lists[indexPath.row].dueDate ?? ""
        cell.editButton?.tag = indexPath.row
        cell.switchButton?.tag = indexPath.row
        
        if lists[indexPath.row].isCompleted {
            cell.switchButton.isOn = true
            cell.listBackground.alpha = 0.2
            cell.listDate.alpha = 0.2
            cell.listTitle.alpha = 0.2
            cell.switchButton.alpha = 0.2
            cell.editButton.alpha = 0.2
        }
        else{
            cell.switchButton.isOn = false
            cell.listBackground.alpha = 1
            cell.listDate.alpha = 1
            cell.listTitle.alpha = 1
            cell.switchButton.alpha = 1
            cell.editButton.alpha = 1
        }
        cell.delegate = self
        return cell
    }
    
}
    //MARK: - List cell delegate
//the below delegate is important because this is where i specify what edit button will do when pressed, i use this function from the protocol i created in ListCell.swift
extension ViewController:ListCellDelegate{
    func completionSwitched(_ sender: UISwitch) {
        let data = lists[sender.tag]
        db.collection(K.collectionName).document(data.name).updateData([
            "iscompleted": sender.isOn
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    func editPressed(_ sender: UIButton) {
        let data = lists[sender.tag]
        self.performSegue(withIdentifier: K.segueName, sender: data)
    }
}

    //MARK: - Table delegate
extension ViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(tableView.cellForRow(at: indexPath)?.textLabel?.text as Any)
    }
}

