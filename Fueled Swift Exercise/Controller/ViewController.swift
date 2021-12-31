//
//  ViewController.swift
//  Fueled Swift Exercise
//
//  Created by Kriti  Agarwal on 28/12/21.
//

import UIKit

class UserEngagement: NSObject {
    var name: String?
    var id: Int?
    var score: Double?
    
}

class ViewController: UIViewController {

    //MARK:- @IBOutlets
    @IBOutlet weak var tableView: UITableView!

    
    //MARK:- Properties
    var userObjs = [UsersModel]()
    var commentObjs = [CommentsModel]()
    var postObjs = [PostsModel]()
    var topBloggersList = [UserEngagement]()
    var sortedTopBloggersList = [UserEngagement]()
    var userScores = [Double]()

    
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
        getTopBloggers()
    }
    
    func getUserData() {
        self.userObjs = []
        if let localUsersData = self.readLocalFile(forName: "Users") {
            do {
                let decodedUserData = try JSONDecoder().decode([UsersModel].self, from: localUsersData)
                self.userObjs = decodedUserData
                self.tableView.reloadData()
            } catch {
                print("decode error")
            }
        }
        
        self.postObjs = []
        guard let localPostsData = self.readLocalFile(forName: "Posts") else { return }
        do {
            let decodedPostsData = try JSONDecoder().decode([PostsModel].self, from: localPostsData)
            self.postObjs = decodedPostsData
            self.tableView.reloadData()
        } catch {
            print("decode error")
        }
        
        self.commentObjs = []
        if let localCommentsData = self.readLocalFile(forName: "Comments") {
            do {
                let decodedCommentsData = try JSONDecoder().decode([CommentsModel].self, from: localCommentsData)
                self.commentObjs = decodedCommentsData
                self.tableView.reloadData()
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
    
    
    func calculateTotalPosts(uid: Int) -> Double {
//        for each in postObjs {
//            if each.id == uid {
//                postsCount += 1
//            }
//        }
        let pCount = postObjs.map{ $0.id == uid }.count
        print("calculateTotalPosts \(uid), \(pCount)")
        return Double(pCount)
    }
    
    func calculateCommentsPerUser(pid: Int) -> Double {
//        for each in commentObjs {
//            if each.postId == pid {
//                count += 1
//            }
//        }
        let cCount = commentObjs.map{ $0.postId == pid }.count
        print("calculateCommentsPerUser \(pid), \(cCount)")
        return Double(cCount)
    }
    
    func calculateTotalComments(uid: Int) -> Double {
        var cCount = 0
        for each in postObjs {
            if (each.userId == uid) {
                cCount = commentObjs.map{ $0.postId == each.id }.count
            }
        }
        print("calculateTotalComments \(uid), \(cCount)")
        return Double(cCount)
    }
    
    func getTopBloggers() {
        var engagementScore = 0.0
        
        for index in 0..<userObjs.count {
            for each in postObjs {
                if each.userId == userObjs[index].id {
                    engagementScore = (calculateTotalComments(uid: each.userId ?? 0) / calculateTotalPosts(uid: each.userId ?? 0))
                    //calculateTotalPosts(uid: each.userId ?? 0) + calculateCommentsPerPost(pid: each.id ?? 0)
                }
            }
            
            self.userScores.append(engagementScore)
        }
        
        for index in 0..<userObjs.count {
            let xyz = UserEngagement()
            xyz.name = self.userObjs[index].name ?? ""
            xyz.score = self.userScores[index]
            xyz.id = self.userObjs[index].id ?? 0
            self.topBloggersList.append(xyz)
        }
        
        let sorted = self.topBloggersList.sorted { obj1, obj2 in
            return obj1.score ?? 0 > obj2.score ?? 0
        }
        self.sortedTopBloggersList = sorted
    }
    
}


//MARK:- TableView Extensions
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sortedTopBloggersList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BlogTableViewCell.identifier, for: indexPath) as! BlogTableViewCell
        cell.setCellData(userName: self.sortedTopBloggersList[indexPath.row].name ?? "", userScore: self.sortedTopBloggersList[indexPath.row].score ?? 0.0, userId: self.sortedTopBloggersList[indexPath.row].id ?? 0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
}
