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
    var userObjs = [UsersModel]()
    var commentObjs = [CommentsModel]()
    var postObjs = [PostsModel]()
    
    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSetup()
        getData()
    }
    
    //MARK:- Extra Methods
    func tableViewSetup() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func getData() {
        getUserData()
        calculateTopBloggers()
    }
    
    func getUserData() {
        self.userObjs = []
        if let localUsersData = self.readLocalFile(forName: "Users") {
            do {
                let decodedUserData = try JSONDecoder().decode([UsersModel].self, from: localUsersData)
                self.userObjs = decodedUserData
            } catch {
                print("decode error")
            }
        }
        
        self.postObjs = []
        guard let localPostsData = self.readLocalFile(forName: "Posts") else { return }
        do {
            let decodedPostsData = try JSONDecoder().decode([PostsModel].self, from: localPostsData)
            self.postObjs = decodedPostsData
        } catch {
            print("decode error")
        }
        
        self.commentObjs = []
        if let localCommentsData = self.readLocalFile(forName: "Comments") {
            do {
                let decodedCommentsData = try JSONDecoder().decode([CommentsModel].self, from: localCommentsData)
                self.commentObjs = decodedCommentsData
            } catch {
                print("decode error")
            }
        }
    }
    
    private func readLocalFile(forName name: String) -> Data? {
        let jsonData : Data?
        if name == "Users" {
            jsonData = Resource.Users.data()
        } else if name == "Posts"  {
            jsonData = Resource.Posts.data()
        } else {
            jsonData = Resource.Comments.data()
        }
        return jsonData
    }
    
    func calculateTopBloggers() {
        // to add comments to each post
        for i in 0..<postObjs.count {
            postObjs[i].commentModel.append(contentsOf: self.commentObjs.filter({$0.postId == postObjs[i].id}))
        }
        
        //to add posts to each user
        for i in 0..<userObjs.count {
            userObjs[i].postModel.append(contentsOf: self.postObjs.filter({$0.userId == userObjs[i].id}))
            var cCount = 0
            for eachPost in userObjs[i].postModel {
                cCount += eachPost.commentModel.count
            }
            
            //to set average comment count for each user
            userObjs[i].avgCount = cCount / userObjs[i].postModel.count
        }
        
        //assign topBlogs with sorted user Array
        self.userObjs = userObjs.sorted { obj1, obj2 in
            return obj1.avgCount > obj2.avgCount
        }
        self.tableView.reloadData()
    }
    
}


//MARK:- TableView Extensions
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userObjs.prefix(3).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BlogTableViewCell.identifier, for: indexPath) as! BlogTableViewCell
        cell.setCellData(userName: self.userObjs[indexPath.row].name ?? "", userScore: self.userObjs[indexPath.row].avgCount , userId: self.userObjs[indexPath.row].id ?? 0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
}
