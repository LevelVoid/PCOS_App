//
//  NutritionTableViewCell.swift
//  PCOS_App
//
//  Created by SDC-USER on 27/11/25.
//

import UIKit

class NutritionTableViewCell: UITableViewCell {

    @IBOutlet weak var nutritionCell: UIView!
    
    static let identifier = "NutritionTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "NutritionTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

        
}
