//
//  FoodLogIngredientHeader.swift
//  PCOS_App
//
//  Created by SDC-USER on 10/12/25.
//

import UIKit

class FoodLogIngredientHeader: UIView {
    
    @IBOutlet weak var FoodImageView: UIImageView!
    
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var carbsLabel: UILabel!
    @IBOutlet weak var fatsLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    
    @IBOutlet weak var macrosContainerStack: UIStackView!
    
    
    private var food: Food?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        // Remove XIB constraints if they exist
        FoodImageView.translatesAutoresizingMaskIntoConstraints = false
        macrosContainerStack.translatesAutoresizingMaskIntoConstraints = false
        
        // Image view styling
        FoodImageView.contentMode = .scaleAspectFill
        FoodImageView.clipsToBounds = true
        FoodImageView.layer.cornerRadius = 12
        
        // Setup programmatic constraints
        setupConstraints()
        
        // Add glass/blur effect to macros container
        addGlassEffect(to: macrosContainerStack)
        
        // Add separators between macros
        addSeparators()
    }
    
    private func setupConstraints() {
        // Make sure views are using auto layout
        FoodImageView.translatesAutoresizingMaskIntoConstraints = false
        macrosContainerStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Food Image constraints
            FoodImageView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            FoodImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            FoodImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            FoodImageView.heightAnchor.constraint(equalToConstant: 200),
            
            // Macros container constraints
            macrosContainerStack.topAnchor.constraint(equalTo: FoodImageView.bottomAnchor, constant: 20),
            macrosContainerStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            macrosContainerStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            macrosContainerStack.heightAnchor.constraint(equalToConstant: 80),
            macrosContainerStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
    
    private func addGlassEffect(to view: UIView) {
        // Remove existing blur effect if any
        view.subviews.filter { $0 is UIVisualEffectView }.forEach { $0.removeFromSuperview() }
        
        // Create blur effect
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.layer.cornerRadius = 12
        blurView.clipsToBounds = true
        
        // Insert blur as background
        view.insertSubview(blurView, at: 0)
        
        // Constrain blur to fill the container
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Make the container background clear so blur shows through
        view.backgroundColor = .clear
        
        // Optional: Add subtle border
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.separator.withAlphaComponent(0.3).cgColor
        view.layer.cornerRadius = 12
    }
    
    private func addSeparators() {
        // Get the vertical stacks from the horizontal stack
        guard macrosContainerStack.arrangedSubviews.count >= 4 else { return }
        
        // Create separators between each section
        for i in stride(from: 1, to: 7, by: 2) {
            if i < macrosContainerStack.arrangedSubviews.count {
                let separator = createSeparator()
                macrosContainerStack.insertArrangedSubview(separator, at: i)
            }
        }
    }
    
    private func createSeparator() -> UIView {
        let separator = UIView()
        separator.backgroundColor = UIColor.separator.withAlphaComponent(0.5)
        separator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            separator.widthAnchor.constraint(equalToConstant: 1),
            separator.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        return separator
    }
    
    // MARK: - Configure
    func configure(with food: Food) {
        self.food = food
        
        // Set image
        if let imageName = food.image {
            FoodImageView.image = UIImage(named: imageName)
        } else {
            FoodImageView.image = UIImage(named: "biryani")
        }
        
        // Update macros with base values
        updateMacros()
    }
    
    private func updateMacros() {
        guard let food = food else { return }
        
        caloriesLabel.text = "\(Int(food.calories)) kcal"
        carbsLabel.text = "\(Int(food.carbsContent)) g"
        fatsLabel.text = "\(Int(food.fatsContent)) g"
        proteinLabel.text = "\(Int(food.proteinContent)) g"
    }
    
    // MARK: - Static Loading (SIMPLIFIED METHOD)
    static func loadFromNib() -> FoodLogIngredientHeader {
        let bundle = Bundle(for: FoodLogIngredientHeader.self)
        let nib = UINib(nibName: "FoodLogIngredientHeader", bundle: bundle)
        
        // Directly load the view from XIB (no File's Owner needed)
        guard let view = nib.instantiate(withOwner: nil, options: nil).first as? FoodLogIngredientHeader else {
            fatalError("Could not load FoodLogIngredientHeader from nib")
        }
        
        return view
    }
}
