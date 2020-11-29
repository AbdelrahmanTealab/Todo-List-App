//
//  ViewController.swift
//  Todo List App
//
//  Created by Abdelrahman  Tealab on 2020-11-13.
//  Student ID: 301164103

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var listTableView: UITableView!

    //a list of random data to test my UX/UI
    var lists:[List] = [
        List(title: "Grocery", dueDate: Date(), items: ["banana","apple","orange"]),
        List(title: "Games", dueDate: Date(), items: ["Red Dead","Cyberpunk","Tekken"]),
        List(title: "Productivity", dueDate: Date(), items: ["Finish app UI","Study iOS","Study UIUX"]),
        List(title: "Music", dueDate: Date(), items: ["Her Mannelig","In The Air Tonight","Unshaken"]),
        List(title: "Some other list", dueDate: Date(), items: ["shave beard","trim hair","wash clothes"])
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        listTableView.dataSource=self
        listTableView.delegate=self
        //registering my custom cell name
        listTableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
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
        cell.listTitle?.text = lists[indexPath.row].title
        cell.listDate?.text = lists[indexPath.row].dueDate?.description(with: Locale(identifier: "en_US"))
        
        cell.delegate = self
        return cell
    }
    
}
    //MARK: - List cell delegate
//the below delegate is important because this is where i specify what edit button will do when pressed, i use this function from the protocol i created in ListCell.swift
extension ViewController:ListCellDelegate{
    func completionSwitched() {
    }
    
    func editPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: K.segueName, sender: self)
    }
    
    
}

    //MARK: - Table delegate
extension ViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(tableView.cellForRow(at: indexPath)?.textLabel?.text as Any)
    }
}

