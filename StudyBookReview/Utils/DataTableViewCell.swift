//
//  DataTableViewCell.swift
//  StudyBookReview
//
//  Created by Anastasia Zimina on 3/22/21.
//

import UIKit

class DataTableViewCell: UITableViewCell {

    @IBOutlet weak var bookPic: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var author: UILabel!
   
    @IBOutlet weak var attitudeImg: UIImageView!
    @IBOutlet weak var review: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
