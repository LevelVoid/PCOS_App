//
//  foodLogIngredientViewController.swift
//  PCOS_App
//
//  Created by SDC-USER on 10/12/25.
//

import UIKit

class foodLogIngredientViewController: UIViewController {

    @IBOutlet weak var servingStepper: UIStepper!
    @IBOutlet weak var servingNumberLabel: UILabel!
    @IBOutlet weak var foodweightView: UIView!
    @IBOutlet weak var FoodWeightLabel: UILabel!
    
    // Header view
    private var headerView: FoodLogIngredientHeader!
        
        // Food data - passed from DietViewController
        var food: Food!
        private var servingMultiplier: Double = 1.0
        
    override func viewDidLoad() {
        super.viewDidLoad()
            
            print("🔍 DEBUG: viewDidLoad started")
            
            // Validate food data exists
            guard food != nil else {
                print("❌ Error: No food data provided")
                navigationController?.popViewController(animated: true)
                return
            }
            
            print("✅ DEBUG: Food data exists - \(food.name)")
            
            // Set navigation title
            title = food?.name ?? "Food Details"
            
            // Setup background color
            view.backgroundColor = .systemBackground
            
            // Setup all constraints programmatically
            setupConstraints()
            
            print("🔍 DEBUG: About to setup header")
            setupHeader()
            
            print("🔍 DEBUG: About to setup stepper")
            setupStepper()
            
            print("🔍 DEBUG: About to update serving display")
            updateServingDisplay()
            
            print("✅ DEBUG: viewDidLoad completed successfully")
        }
        
        // MARK: - Setup Constraints
        private func setupConstraints() {
            // Enable auto layout for all outlets
            foodweightView.translatesAutoresizingMaskIntoConstraints = false
            servingNumberLabel.translatesAutoresizingMaskIntoConstraints = false
            servingStepper.translatesAutoresizingMaskIntoConstraints = false
            FoodWeightLabel.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                // foodweightView - Header container
                foodweightView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                foodweightView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                foodweightView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                foodweightView.heightAnchor.constraint(equalToConstant: 320),
                
                // servingNumberLabel - "1 serving" label
                servingNumberLabel.topAnchor.constraint(equalTo: foodweightView.bottomAnchor, constant: 24),
                servingNumberLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                
                // servingStepper - Stepper control
                servingStepper.centerYAnchor.constraint(equalTo: servingNumberLabel.centerYAnchor),
                servingStepper.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                servingStepper.leadingAnchor.constraint(greaterThanOrEqualTo: servingNumberLabel.trailingAnchor, constant: 20),
                
                // FoodWeightLabel - "Weight Total" label
                FoodWeightLabel.topAnchor.constraint(equalTo: servingStepper.bottomAnchor, constant: 24),
                FoodWeightLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                FoodWeightLabel.widthAnchor.constraint(equalToConstant: 120),
                FoodWeightLabel.heightAnchor.constraint(equalToConstant: 60)
            ])
            
            // Style the weight label
            FoodWeightLabel.backgroundColor = .systemGray6
            FoodWeightLabel.layer.cornerRadius = 12
            FoodWeightLabel.clipsToBounds = true
            FoodWeightLabel.textAlignment = .center
            FoodWeightLabel.numberOfLines = 2
            FoodWeightLabel.font = .systemFont(ofSize: 14, weight: .medium)
        }
        
        // MARK: - Setup Header
        private func setupHeader() {
            print("🔍 DEBUG: setupHeader - Start")
            
            guard let food = food else {
                print("❌ Error: No food data available")
                return
            }
            
            print("✅ DEBUG: Food available in setupHeader")
            
            guard let containerView = foodweightView else {
                print("❌ Error: foodweightView outlet is not connected!")
                return
            }
            
            print("✅ DEBUG: foodweightView outlet connected")
            
            // Clear container
            containerView.subviews.forEach { $0.removeFromSuperview() }
            
            // Load header from nib
            print("🔍 DEBUG: About to load header from nib")
            headerView = FoodLogIngredientHeader.loadFromNib()
            print("✅ DEBUG: Header loaded from nib")
            
            // Add header view to container
            containerView.addSubview(headerView)
            
            // Setup constraints
            headerView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                headerView.topAnchor.constraint(equalTo: containerView.topAnchor),
                headerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                headerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                headerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])
            
            print("🔍 DEBUG: About to configure header with food")
            // Configure with food data
            headerView.configure(with: food)
            print("✅ DEBUG: setupHeader - Complete")
        }
        
        // MARK: - Setup Stepper
        private func setupStepper() {
            guard let stepper = servingStepper else {
                print("❌ Error: servingStepper outlet is not connected!")
                return
            }
            
            stepper.minimumValue = 0.5
            stepper.maximumValue = 10.0
            stepper.stepValue = 0.5
            stepper.value = 1.0
            servingMultiplier = 1.0
            
            // Style the stepper
            stepper.backgroundColor = .systemGray6
            stepper.layer.cornerRadius = 8
        }
        
        // MARK: - Actions
        @IBAction func servingStepperChanged(_ sender: UIStepper) {
            servingMultiplier = sender.value
            updateServingDisplay()
            updateMacros()
        }
        
        // MARK: - Update Display
        private func updateServingDisplay() {
            // Update serving label
            let servingText: String
            if servingMultiplier == 1.0 {
                servingText = "1 serving"
            } else {
                servingText = String(format: "%.1f servings", servingMultiplier)
            }
            
            if let label = servingNumberLabel {
                label.text = servingText
                label.font = .systemFont(ofSize: 18, weight: .semibold)
            } else {
                print("⚠️ Warning: servingNumberLabel is nil")
            }
            
            // Update weight label
            guard let food = food else {
                print("⚠️ Warning: food is nil")
                return
            }
            
            if let weight = food.weight {
                let totalWeight = Int(weight * servingMultiplier)
                if let label = FoodWeightLabel {
                    label.text = "Weight Total\n\(totalWeight) g"
                } else {
                    print("⚠️ Warning: FoodWeightLabel is nil")
                }
            } else {
                // Fallback to quantity if weight is not available
                let totalQuantity = Int(food.quantity * servingMultiplier)
                if let label = FoodWeightLabel {
                    label.text = "Weight Total\n\(totalQuantity) g"
                } else {
                    print("⚠️ Warning: FoodWeightLabel is nil")
                }
            }
        }
        
        private func updateMacros() {
            guard let food = food else { return }
            
            // Create a temporary food object with multiplied values
            var multipliedFood = food
            multipliedFood.proteinContent = food.proteinContent * servingMultiplier
            multipliedFood.carbsContent = food.carbsContent * servingMultiplier
            multipliedFood.fatsContent = food.fatsContent * servingMultiplier
            multipliedFood.fibreContent = food.fibreContent * servingMultiplier
            
            // Update weight if available
            if let weight = food.weight {
                multipliedFood.weight = weight * servingMultiplier
            }
            
            // Update custom calories if set
            if let customCalories = food.customCalories {
                multipliedFood.customCalories = customCalories * servingMultiplier
            }
            
            // Update ingredients if available
            if let ingredients = food.ingredients {
                multipliedFood.ingredients = ingredients.map { ingredient in
                    var newIngredient = ingredient
                    newIngredient.quantity = ingredient.quantity * servingMultiplier
                    return newIngredient
                }
            }
            
            headerView.configure(with: multipliedFood)
        }
        
        // MARK: - Static Presentation
        static func present(from viewController: UIViewController, with food: Food) {
            guard let storyboard = viewController.storyboard ?? UIStoryboard(name: "Main", bundle: nil) as UIStoryboard? else {
                print("❌ Error: Could not load storyboard")
                return
            }
            
            guard let ingredientVC = storyboard.instantiateViewController(withIdentifier: "foodLogIngredientViewController") as? foodLogIngredientViewController else {
                print("❌ Error: Could not instantiate foodLogIngredientViewController")
                return
            }
            
            ingredientVC.food = food
            
            if let navController = viewController.navigationController {
                navController.pushViewController(ingredientVC, animated: true)
            } else {
                print("❌ Error: No navigation controller found")
            }
        }
    }
