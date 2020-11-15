//
//  ViewController.swift
//  Todo List App
//
//  Created by Abdelrahman  Tealab on 2020-11-13.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var listTableView: UITableView!

    var lists:[List] = [
        List(title: "Grocery", dueDate: Date(), items: ["banana","apple","orange"]),
        List(title: "Games", dueDate: Date(), items: ["Red Dead","Cyberpunk","Tekken"]),
        List(title: "Productivity", dueDate: Date(), items: ["Finish app UI","Study iOS","Study UIUX"]),
        List(title: "Music", dueDate: Date(), items: ["Her Mannelig","In The Air Tonight","Unshaken"]),
        List(title: "Random list", dueDate: Date(), items: ["shave beard","trim hair","wash clothes"])
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        listTableView.dataSource=self
        listTableView.delegate=self
        
        listTableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        // Do any additional setup after loading the view.
    }
}

extension ViewController:UITableViewDataSource{
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listTableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! ListCell
        cell.listTitle?.text = lists[indexPath.row].title
        cell.listDate?.text = lists[indexPath.row].dueDate?.description(with: Locale(identifier: "en_US"))
        
        cell.delegate = self
        return cell
    }
    
}

extension ViewController:ListCellDelegate{
    func completionSwitched() {
    }
    
    func editPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: K.segueName, sender: self)
    }
    
    
}

extension ViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(tableView.cellForRow(at: indexPath)?.textLabel?.text as Any)
    }
}

