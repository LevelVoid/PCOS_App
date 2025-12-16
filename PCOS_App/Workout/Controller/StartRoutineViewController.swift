//
//  StartRoutineViewController.swift
//  PCOS_App
//
//  Created by SDC-USER on 08/12/25.
//

import UIKit

class StartRoutineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activeWorkout.exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "start_routine_exercise_cell",
                for: indexPath
            ) as? StartRoutineExerciseTableViewCell else {
                return UITableViewCell()
            }

            let WokorkoutExercise = activeWorkout.exercises[indexPath.row]

            cell.configure(with: WokorkoutExercise)
            
        
        
        cell.onDoneTapped = { [weak self] isCompleted in
            self?.toggleSet(
                exerciseIndex: indexPath.row,
                isCompleted: isCompleted
            )
        }

        let exercise = activeWorkout.exercises[indexPath.row].exercise
        cell.onInfoTapped = { [weak self] in
            guard let self = self else { return }
            self.performSegue(withIdentifier: "InfoModal", sender: exercise)
        }

            return cell
        }
    func toggleSet(exerciseIndex: Int, isCompleted: Bool) {
        // Mark ALL sets as complete for this exercise
            for i in 0..<activeWorkout.exercises[exerciseIndex].sets.count {
                activeWorkout.exercises[exerciseIndex].sets[i].isCompleted = isCompleted
            }

        // Recalculate everything
        updateProgress()
        updateStats()

        // Reload only this row
        startRoutineTableView.reloadRows(
            at: [IndexPath(row: exerciseIndex, section: 0)],
            with: .automatic
        )
    }


    var activeWorkout: ActiveWorkout!
    var globalTimer: Timer?
    // Which routine to load (pass this from previous screen)
        var selectedRoutineIndex: Int = 0  // Default to first routine
        
        var totalSets: Int {
            activeWorkout.exercises.flatMap { $0.sets }.count
        }
        
        var completedSets: Int {
            activeWorkout.exercises.flatMap { $0.sets }.filter { $0.isCompleted }.count
        }
        
        var completedExercises: Int {
            activeWorkout.exercises.filter { exercise in
                exercise.sets.allSatisfy { $0.isCompleted }
            }.count
        }



    @IBOutlet weak var routineProgressBar: UIView!
    @IBOutlet weak var setCountOutlet: UILabel!
    @IBOutlet weak var finishRoutineButton: UIBarButtonItem!
    @IBOutlet weak var exercisesCountOutlet: UILabel!
    @IBOutlet weak var durationLabelOutlet: UILabel!
    
    @IBOutlet weak var progressWidthConstraint: NSLayoutConstraint!

    @IBOutlet weak var routineNameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
 
        progressWidthConstraint.constant = 0
        
        // 1️⃣ Get the active workout that was set earlier
            guard let session = WorkoutSessionManager.shared.activeWorkout else {
                print("❌ No active workout found!")
                navigationController?.popViewController(animated: true)
                return
            }

            activeWorkout = session

            print("🏋️ Starting routine: \(session.routine.name)")
            print("📋 Exercises count: \(session.exercises.count)")

            // 2️⃣ Set UI
            title = session.routine.name

            // 3️⃣ Setup Table
            startRoutineTableView.delegate = self
            startRoutineTableView.dataSource = self
        startRoutineTableView.rowHeight = UITableView.automaticDimension
        startRoutineTableView.estimatedRowHeight = 200
            setupTable()

            // 4️⃣ Start timer
            startMainTimer()

            // 5️⃣ Update stats & progress
            updateStats()
            updateProgress()
        definesPresentationContext = true
    }
    
    @IBOutlet weak var startRoutineTableView: UITableView!
    
    func setupTable() {
        
        startRoutineTableView.register(
            UINib(nibName: "StartRoutineExerciseTableViewCell", bundle: nil),
            forCellReuseIdentifier: "start_routine_exercise_cell"
        )
    }
    func startMainTimer() {
        globalTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            let elapsed = Int(Date().timeIntervalSince(self.activeWorkout.startTime))
            let minutes = elapsed / 60
            let seconds = elapsed % 60
            // ✅ Shows "7:23" format
            self.durationLabelOutlet.text = String(format: "%d:%02d", minutes, seconds)
            //updates the timer of activie workout model 
            self.activeWorkout.durationSeconds = elapsed
        }
    }
    func updateStats() {

        // Show completed exercises
        exercisesCountOutlet.text = "\(completedExercises)"

        // Show completed sets
        setCountOutlet.text = "\(completedSets)"

        // Ignore volume as per your requirement
    }
    func updateProgress() {
        let total = totalSets
        let done = completedSets
        
        let progress = total == 0 ? 0 : CGFloat(done) / CGFloat(total)

        let maxWidth = view.frame.width - 40  // adjust based on layout
        let newWidth = maxWidth * progress

        UIView.animate(withDuration: 0.25) {
            self.progressWidthConstraint.constant = newWidth
            self.view.layoutIfNeeded()
        }
    }


    @IBAction func finishRoutineTapped(_ sender: UIBarButtonItem) {

        let alert = UIAlertController(
            title: "Finish Workout?",
            message: "Do you want to save this workout?",
            preferredStyle: .actionSheet
        )

        alert.addAction(UIAlertAction(title: "Save Workout", style: .default) { _ in
            self.handleSaveWorkout()
        })

        alert.addAction(UIAlertAction(title: "Discard", style: .destructive) { _ in
            self.navigationController?.popViewController(animated: true)
        })

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(alert, animated: true)
    }


    func handleSaveWorkout() {
        globalTimer?.invalidate()

        // Authoritative duration calculation
        let elapsed = Int(Date().timeIntervalSince(activeWorkout.startTime))
        activeWorkout.durationSeconds = elapsed

        activeWorkout.finish()

        let completedWorkout = CompletedWorkout(
            routineName: activeWorkout.routine.name,
            date: Date(),
            durationSeconds: elapsed,   //  guaranteed correct
            exercises: activeWorkout.exercises
        )

        WorkoutSessionManager.shared.completedWorkouts.append(completedWorkout)

        
//        // Hide nav + tab bar FIRST
//            navigationController?.setNavigationBarHidden(true, animated: false)
//            tabBarController?.tabBar.isHidden = true
        let summaryVC = UIStoryboard(name: "Workout", bundle: nil)
            .instantiateViewController(withIdentifier: "SummaryViewController") as! SummaryViewController

        summaryVC.completedWorkout = completedWorkout
        //ABHI
//        navigationController?.pushViewController(summaryVC, animated: true)
        
        summaryVC.modalPresentationStyle = .overFullScreen
      //  summaryVC.modalPresentationStyle = .overCurrentContext
            summaryVC.modalTransitionStyle = .crossDissolve

            present(summaryVC, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        if segue.identifier == "InfoModal" {
            // If you embedded InfoModal inside a UINavigationController, handle that:
            if let nav = segue.destination as? UINavigationController,
               let infoVC = nav.topViewController as? InfoModalViewController {
                if let exercise = sender as? Exercise {
                    infoVC.exercise = exercise
                }
            } else if let infoVC = segue.destination as? InfoModalViewController {
                if let exercise = sender as? Exercise {
                    infoVC.exercise = exercise
                }
            } else {
                // Optional: Debugging fallback
                print("Warning: destination VC is not InfoModalViewController")
            }
        }
    }


}
