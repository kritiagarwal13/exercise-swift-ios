//
//  ViewController.swift
//  Fueled Swift Exercise
//
//  Created by Kriti  Agarwal on 28/12/21.
//

import UIKit

class ViewController: UIViewController {

    //MARK:- @IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK:- Properties
//    var userObj = User()
    
    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSetup()
        initialSetup()
    }


    //MARK:- Extra Methods
    func initialSetup() {
        
    }
    
    func tableViewSetup() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(BlogTableViewCell.self, forCellReuseIdentifier: BlogTableViewCell.identifier)
    }
    
    //MARK:- @IBActions
}

//MARK:- TableView Extensions
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BlogTableViewCell.identifier, for: indexPath) as! BlogTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}
