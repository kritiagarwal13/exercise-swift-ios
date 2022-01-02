//
//  BlogTableViewCell.swift
//  Fueled Swift Exercise
//
//  Created by Kriti  Agarwal on 28/12/21.
//

import UIKit

class BlogTableViewCell: UITableViewCell {

    //MARK:- @IBOutlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var userScoreLabel: UILabel!
    
    
    //MARK:- Properties
    static let identifier = "BlogTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "BlogTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    //MARK:- Extra Methods
    func setCellData(userName: String?, userScore: Int?, userId:Int?) {
        self.nameLabel.text = userName ?? ""
        self.userIdLabel.text = "\(String(describing: userId ?? 0))"
        self.userScoreLabel.text = "\(userScore ?? 0)"
    }
    
}
