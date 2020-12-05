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

    @IBOutlet weak var plusButton: UIButton!
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
        plusButton.layer.cornerRadius = 0.5 * plusButton.bounds.size.width
        plusButton.clipsToBounds = true
        listTableView.dataSource=self
        listTableView.delegate=self
        //registering my custom cell name
        listTableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        loadTodos()
    }
    
    //MARK: - LOAD
    func loadTodos(){
        //this is where i load todos from the DB
        //i used addSnapshotListener because it refreshed the function everytime there's an update in the DB
        //when there's an update i call reloadData function in the main thread to avoid crashing
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
    //prepare for segue to send my data when editing the cell or todo
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == K.segueName) {
            let destinationVC = (segue.destination as! DetailsViewController)
            destinationVC.name = (sender as! List).name
            destinationVC.notes = (sender as! List).notes
            destinationVC.duedate = (sender as! List).dueDate
            destinationVC.completed = (sender as! List).isCompleted
        }
    }
    
    //MARK: - Swipe actions
    func completeAction(at indexPath: IndexPath) -> UIContextualAction {
        let todo = lists[indexPath.row]
        let action = UIContextualAction(style: .normal, title: "Completed") { (action, view, completion) in
            self.db.collection(K.collectionName).document(todo.name).updateData([
                "iscompleted": !todo.isCompleted
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
            completion(true)
        }
        action.image = UIImage(systemName: "checkmark")?.withRenderingMode(.alwaysOriginal)
            action.image?.withTintColor(.black)
        action.backgroundColor = todo.isCompleted ? .gray : .green
        return action
    }
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let todo = lists[indexPath.row]
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            self.db.collection(K.collectionName).document(todo.name).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                }
            }
            completion(true)
        }
        action.image = UIImage(systemName: "trash.slash")
        action.backgroundColor = .red
        return action
    }
    func editAction(at indexPath: IndexPath) -> UIContextualAction {
        let todo = lists[indexPath.row]
        let action = UIContextualAction(style: .normal, title: "Edit") { (action, view, completion) in
            self.performSegue(withIdentifier: K.segueName, sender: todo)
            completion(true)
        }
        action.image = UIImage(systemName: "pencil")
        action.backgroundColor = .blue
        return action
    }
}
//Extensions
    //MARK: - Table data source
extension ViewController:UITableViewDataSource{
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //returning the number of items in the list to display it as the number of rows
        return lists.count
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let complete = completeAction(at: indexPath)
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete,complete])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = editAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [edit])
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //setting my cell as ListCell as this is my custom cell
        let cell = listTableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! ListCell
        //setting the title and dates of the custom cell as well as assigning numbers to the buttons tags so i can access their data easily later
        cell.listTitle?.text = lists[indexPath.row].name
        cell.listDate?.text = lists[indexPath.row].dueDate ?? ""
        //this is to grey out cells that are completed
        if lists[indexPath.row].isCompleted {
            cell.listBackground.alpha = 0.2
            cell.listDate.alpha = 0.2
            cell.listTitle.alpha = 0.2
        }
        //this is show cells that are not completed
        else{

            cell.listBackground.alpha = 1
            cell.listDate.alpha = 1
            cell.listTitle.alpha = 1
        }
        return cell
    }
    
}

    //MARK: - Table delegate
extension ViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(tableView.cellForRow(at: indexPath)?.textLabel?.text as Any)
    }
}
