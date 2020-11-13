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
        // Do any additional setup after loading the view.
    }
}

extension ViewController:UITableViewDataSource{
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listTableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath)
        cell.textLabel?.text = lists[indexPath.row].title
        cell.detailTextLabel?.text = lists[indexPath.row].dueDate?.description(with: Locale(identifier: "en_US"))
        return cell
    }
}

