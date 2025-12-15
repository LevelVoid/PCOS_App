//
//  SummaryViewController.swift
//  PCOS_App
//
//  Created by SDC-USER on 11/12/25.
//

import UIKit

class SummaryViewController: UIViewController {
    
    
    var completedWorkout: CompletedWorkout!

        // Goals (you can fetch these from user settings)
        let caloriesGoal = 600.0
        let durationGoalSeconds = 120 * 60  // 2 hours

        @IBOutlet weak var caloriesValueLabel: UILabel!
        @IBOutlet weak var caloriesGoalLabel: UILabel!

        @IBOutlet weak var exercisesDoneLabel: UILabel!

        @IBOutlet weak var durationValueLabel: UILabel!
        @IBOutlet weak var durationGoalLabel: UILabel!

       // @IBOutlet weak var trophyImageView: UIImageView!

        @IBOutlet weak var caloriesCard: UIView!
        @IBOutlet weak var exercisesCard: UIView!
        @IBOutlet weak var durationCard: UIView!

        override func viewDidLoad() {
            super.viewDidLoad()
            setupUI()
            applyCardStyling()
            showConfetti()
        }

        func setupUI() {

            // ---- DURATION ----
            let totalSeconds = completedWorkout.durationSeconds
            durationValueLabel.text = formatDuration(totalSeconds)
            durationGoalLabel.text = "/ " + formatDuration(durationGoalSeconds)

            // ---- CALORIES ----
            let calories = Double(totalSeconds) * 0.18
            caloriesValueLabel.text = String(format: "%.0f", calories)
            caloriesGoalLabel.text = "/\(Int(caloriesGoal))"

            // ---- EXERCISES DONE ----
            let completedExercises = completedWorkout.exercises.filter {
                $0.sets.allSatisfy { $0.isCompleted }
            }.count

            exercisesDoneLabel.text = "\(completedExercises)"
        }

        func applyCardStyling() {
            let cards = [caloriesCard, exercisesCard, durationCard]
            cards.forEach { card in
                card?.layer.cornerRadius = 20
                card?.layer.shadowColor = UIColor.black.cgColor
                card?.layer.shadowOpacity = 0.08
                card?.layer.shadowOffset = CGSize(width: 0, height: 3)
                card?.layer.shadowRadius = 6
                card?.layer.masksToBounds = false
            }
        }

        func formatDuration(_ seconds: Int) -> String {
            let hrs = seconds / 3600
            let mins = (seconds % 3600) / 60

            if hrs > 0 {
                return "\(hrs)h \(mins)min"
            } else {
                return "\(mins)min"
            }
        }

        
    
    func showConfetti() {
        let confettiLayer = CAEmitterLayer()

        confettiLayer.emitterPosition = CGPoint(x: view.bounds.width / 2, y: -10)
        confettiLayer.emitterShape = .line
        confettiLayer.emitterSize = CGSize(width: view.bounds.size.width, height: 1)

        // Confetti Colors
        let colors: [UIColor] = [
            .systemYellow,
            .systemPink,
            .systemPurple,
            .systemGreen,
            .systemOrange,
            .systemBlue
        ]

        // Confetti Shapes
        let shapes: [String] = ["square", "triangle", "circle"]

        var cells: [CAEmitterCell] = []

        for color in colors {
            for shape in shapes {
                let cell = CAEmitterCell()
                cell.birthRate = 4
                cell.lifetime = 6.0
                cell.lifetimeRange = 2
                cell.velocity = CGFloat.random(in: 100...200)
                cell.velocityRange = 50
                cell.emissionLongitude = .pi
                cell.emissionRange = .pi / 4
                cell.spin = 3.5
                cell.spinRange = 2

                cell.scale = 0.15
                cell.scaleRange = 0.1

                cell.color = color.cgColor
                cell.contents = confettiImage(shape: shape)?.cgImage

                cells.append(cell)
            }
        }

        confettiLayer.emitterCells = cells
        view.layer.addSublayer(confettiLayer)

        // Remove after 5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            confettiLayer.birthRate = 0
        }
    }
    func confettiImage(shape: String) -> UIImage? {
        let size = CGSize(width: 12, height: 12)

        UIGraphicsBeginImageContext(size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }

        switch shape {
        case "square":
            context.fill(CGRect(origin: .zero, size: size))

        case "triangle":
            context.beginPath()
            context.move(to: CGPoint(x: size.width/2, y: 0))
            context.addLine(to: CGPoint(x: 0, y: size.height))
            context.addLine(to: CGPoint(x: size.width, y: size.height))
            context.closePath()
            context.fillPath()

        case "circle":
            context.fillEllipse(in: CGRect(origin: .zero, size: size))

        default:
            break
        }

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    @IBAction func doneButtonTapped(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
}
