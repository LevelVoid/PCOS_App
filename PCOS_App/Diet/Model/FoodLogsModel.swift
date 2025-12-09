//
//  FoodDataSource.swift
//  PCOS_App
//
//  Created by SDC-USER on 09/12/25.
//

import Foundation

struct Food: Codable, Identifiable {
    let id: UUID
    var name: String
    var image: String?
    var timeStamp: Date
    var quantity: Double
    
    // Base macros (if not ingredient-based)
    var proteinContent: Double
    var carbsContent: Double
    var fatsContent: Double
    var fibreContent: Double
    
    // Optional override
    var customCalories: Double?
    
    // Tags
    var tags: [ImpactTags]
    
    // Ingredient list
    var ingredients: [Ingredient]? = nil
    
    var calories: Double {
        if let customCalories = customCalories {
            return customCalories
        }
        if let ingredients {
                    return ingredients.reduce(0) { $0 + $1.calories }
                }
        return ((proteinContent * 4) +
                (carbsContent * 4) +
                (fatsContent * 9)).rounded(toPlaces: 2)

            }
       
}
