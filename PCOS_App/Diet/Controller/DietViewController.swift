//
//  DietViewController.swift
//  PCOS_App
//
//  Created by SDC-USER on 24/11/25.
//

import UIKit

class DietViewController: UIViewController {

    var todaysFoods: [Food] = [] //sks: to filter food for today
    
    var dummyData = FoodLogDataSource.sampleFoods
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var AddMealButton: UIButton!
    

    override func viewDidLoad() {
            super.viewDidLoad()
            title = "Diet"
            navigationController?.navigationBar.prefersLargeTitles = true
            
            let calendar = UIBarButtonItem(image: UIImage(systemName: "calendar"), style: .plain, target: self, action: #selector(calendarTapped))
            navigationItem.rightBarButtonItem = calendar
            
            let header = Bundle.main.loadNibNamed("NutritionHeader", owner: self, options: nil)?.first as! NutritionHeader
            tableView.tableHeaderView = header
            header.configure()
            header.frame.size.height = 460
            
            tableView.register(LogsTableViewCell.nib(), forCellReuseIdentifier: LogsTableViewCell.identifier)
            tableView.dataSource = self
            tableView.delegate = self
            
            setupAddButton()
            AddMealButton.addTarget(self, action: #selector(addButtonTapped(_:)), for: .touchUpInside)
            
            filterTodaysFoods()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            filterTodaysFoods()
        }
        
        private func filterTodaysFoods() {
            let startOfToday = Calendar.current.startOfDay(for: Date())
            let startOfTomorrow = Calendar.current.date(byAdding: .day, value: 1, to: startOfToday)!
            
            todaysFoods = dummyData.filter { food in
                food.timeStamp >= startOfToday && food.timeStamp < startOfTomorrow
            }
            
            todaysFoods.sort { $0.timeStamp > $1.timeStamp }
            tableView.reloadData()
            
//<<<<<<< HEAD
            // Debug: Print how many foods found for today
            print(" Found \(todaysFoods.count) foods for today")
    }
    
    private func setupAddButton() {
        AddMealButton.backgroundColor = UIColor.systemPink
        AddMealButton.setTitle("Add", for: .normal)
        AddMealButton.setTitleColor(.white, for: .normal)
        AddMealButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        AddMealButton.layer.cornerRadius = 25
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        AddMealViewController.present(from: self)
        
    }
    
    @objc func calendarTapped() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "dietLogs") as? DietCalendarLogsViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}


extension DietViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todaysFoods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: LogsTableViewCell.identifier, for: indexPath) as! LogsTableViewCell
        let item = todaysFoods[indexPath.row] //sks: made changes here
        cell.configure(with: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}

extension DietViewController {
    func createAddButtonProgrammatically() {
        let addButton = UIButton(type: .system)
        addButton.backgroundColor = UIColor(hex:"fe7a96")
        addButton.setTitle("Add", for: .normal)
        addButton.setTitleColor(.white, for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        addButton.layer.cornerRadius = 25
        addButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(addButton)

        NSLayoutConstraint.activate([
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80),
            addButton.widthAnchor.constraint(equalToConstant: 100),
            addButton.heightAnchor.constraint(equalToConstant: 50)
        ])

        addButton.addTarget(self, action: #selector(addButtonTappedProgrammatic), for: .touchUpInside)
    }

    @objc private func addButtonTappedProgrammatic() {
        let addMealVC = AddMealViewController()
        addMealVC.delegate = self
        present(addMealVC, animated: true)
    }
}

extension DietViewController: AddMealDelegate {
    func didAddMeal(_ food: Food) {
        //=======
        //            print("Found \(todaysFoods.count) foods for today")
        //        }
        //
        //        private func setupAddButton() {
        //            AddMealButton.backgroundColor = UIColor.systemPink
        //            AddMealButton.setTitle("Add", for: .normal)
        //            AddMealButton.setTitleColor(.white, for: .normal)
        //            AddMealButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        //            AddMealButton.layer.cornerRadius = 25
        //        }
        //
        //        @IBAction func addButtonTapped(_ sender: UIButton) {
        //            AddMealViewController.present(from: self)
        //        }
        //
        //        @objc func calendarTapped() {
        //            if let vc = storyboard?.instantiateViewController(withIdentifier: "dietLogs") as? DietCalendarLogsViewController {
        //                navigationController?.pushViewController(vc, animated: true)
        //            }
        //        }
        //    }
        //
        //    extension DietViewController: UITableViewDataSource, UITableViewDelegate {
        //        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //            return todaysFoods.count
        //        }
        //
        //        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //            let cell = tableView.dequeueReusableCell(withIdentifier: LogsTableViewCell.identifier, for: indexPath) as! LogsTableViewCell
        //            let item = todaysFoods[indexPath.row]
        //            cell.configure(with: item)
        //            return cell
        //        }
        //
        //        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //            return 100
        //        }
        //
        //        // MARK: - Handle Row Selection
        //        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //            tableView.deselectRow(at: indexPath, animated: true)
        //
        //            let selectedFood = todaysFoods[indexPath.row]
        //
        //            // Navigate to foodLogIngredientViewController
        //            foodLogIngredientViewController.present(from: self, with: selectedFood)
        //        }
        //    }
        //
        //    extension DietViewController {
        //        func createAddButtonProgrammatically() {
        //            let addButton = UIButton(type: .system)
        //            addButton.backgroundColor = UIColor(hex:"fe7a96")
        //            addButton.setTitle("Add", for: .normal)
        //            addButton.setTitleColor(.white, for: .normal)
        //            addButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        //            addButton.layer.cornerRadius = 25
        //            addButton.translatesAutoresizingMaskIntoConstraints = false
        //
        //            view.addSubview(addButton)
        //
        //            NSLayoutConstraint.activate([
        //                addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
        //                addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80),
        //                addButton.widthAnchor.constraint(equalToConstant: 100),
        //                addButton.heightAnchor.constraint(equalToConstant: 50)
        //            ])
        //
        //            addButton.addTarget(self, action: #selector(addButtonTappedProgrammatic), for: .touchUpInside)
        //        }
        //
        //        @objc private func addButtonTappedProgrammatic() {
        //            let addMealVC = AddMealViewController()
        //            addMealVC.delegate = self
        //            present(addMealVC, animated: true)
        //        }
        //    }
        //
        //
        //extension DietViewController: AddMealDelegate {
        //    func didAddMeal(_ food:Food){
        //>>>>>>> 5d2835b (ingredinet logs)
        FoodLogDataSource.addFoodBarCode(food)
        todaysFoods.append(food)
        dummyData.append(food)
        filterTodaysFoods()
        tableView.reloadData()
        print(food)
    }
}
