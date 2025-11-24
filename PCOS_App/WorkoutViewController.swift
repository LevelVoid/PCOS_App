//
//  WorkoutViewController.swift
//  PCOS_App
//
//  Created by SDC-USER on 24/11/25.
//

import UIKit

class WorkoutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Workout"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addWorkout))
    }
    
    @objc func addWorkout() {
        let vc = AddWorkoutViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    

}
