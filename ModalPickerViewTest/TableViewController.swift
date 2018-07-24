//
//  TableViewController.swift
//  ModalPickerViewTest
//
//  Created by Rayhan Janam on 6/13/18.
//  Copyright © 2018 Rayhan Janam. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    let bloodGroupData = ["A+", "B+", "AB+", "O+", "A-", "B-", "AB-", "O-"]
    let divisionData = ["Dhaka", "Chottogram", "Rajshahi", "Khulna", "Borishal", "Sylhet", "Rangpur", "Moymonsingh"]
    
    var bloodGroup: String!
    var date: String!
    var division: String!
    
    let transitionController = RNTransitionController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bloodGroup = ""
        date = ""
        division = ""
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        default:
            return 1
        }
    }

    @IBAction func setDatePressed(_ sender: Any) {
        showModalPickerView(type: .date, pickerData: nil) { (date) in
            self.date = date
            if let sender = sender as? UIButton {
                sender.setTitle(date, for: .normal)
            }
        }
    }
        
    @IBAction func setBloodGroup(_ sender: Any) {
        showModalPickerView(type: .normal, pickerData: bloodGroupData) { (data) in
            self.bloodGroup = data
            if let sender = sender as? UIButton {
                sender.setTitle(data, for: .normal)
            }
        }
    }
    
    @IBAction func setDivisionTapped(_ sender: Any) {
        showModalPickerView(type: .normal, pickerData: divisionData) { (data) in
            self.division = data
            if let sender = sender as? UIButton {
                sender.setTitle(data, for: .normal)
            }
        }
    }
    
    @IBAction func setDataTapped(_ sender: Any) {
        
        var message: String!
        
        if date.count > 0 && bloodGroup.count > 0 && division.count > 0 {
            message = "\(date!)\n\(bloodGroup!)\n\(division!)"
        } else {
            message = "Fill up the form!"
        }
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
    }
    
    fileprivate func showModalPickerView(type: PickerType, pickerData: [String]?, onDismiss: ((String) -> Void)?) {
        
        if let pickerController = storyboard?.instantiateViewController(withIdentifier: "ModalPickerViewController") as? ModalPickerViewController {
            
            pickerController.pickerType = type
            pickerController.dataSource = pickerData
            pickerController.onDismiss = onDismiss
            
//            pickerController.modalTransitionStyle = .crossDissolve
//            pickerController.modalPresentationStyle = .overCurrentContext
//
//            present(pickerController, animated: true, completion: nil)
            
            transitionController.present(viewController: pickerController, from: self, animation: .fadeInWithSubviewZoomIn, duration: RNTransitionAnimationDuration, subviewTag: 663)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}













