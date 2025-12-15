//
//  PredefinedExerciseTableViewCell.swift
//  PCOS_App
//
//  Created by SDC-USER on 11/12/25.
//

import UIKit

class PredefinedExerciseTableViewCell: UITableViewCell {
        @IBOutlet weak var thumbnailImage: UIImageView!
        @IBOutlet weak var exerciseNameLabel: UILabel!
        @IBOutlet weak var detailLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
