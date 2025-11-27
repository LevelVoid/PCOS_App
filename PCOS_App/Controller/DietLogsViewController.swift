//
//  DietLogsViewController.swift
//  PCOS_App
//
//  Created by SDC-USER on 26/11/25.
//

import UIKit


class DietLogsViewController: UIViewController {
    
    var dummyData = DataStore.sampleFoods
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var loggedMeal: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Diet Logs"
        navigationItem.largeTitleDisplayMode = .never
        loggedMeal.delegate = self
        loggedMeal.dataSource = self
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
    }
    
    @objc func datePickerValueChanged() {
        print(datePicker.date)
    }
    

}



extension DietLogsViewController: UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = dummyData[indexPath.row].name
        cell.detailTextLabel?.text = "\(dummyData[indexPath.row].calories) kcal"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}



