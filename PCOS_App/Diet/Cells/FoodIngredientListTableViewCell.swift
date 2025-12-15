//
//  FoodIngredientListTableViewCell.swift
//  PCOS_App
//
//  Created by SDC-USER on 13/12/25.
//

import UIKit

class FoodIngredientListTableViewCell: UITableViewCell {

    @IBOutlet weak var IngedientNameLabel: UILabel!
    @IBOutlet weak var IngredientCalorieLabel: UILabel!
    
    @IBOutlet weak var IngredientWeightLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
