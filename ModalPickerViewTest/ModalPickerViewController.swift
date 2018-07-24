//
//  ViewController.swift
//  ModalPickerViewTest
//
//  Created by Rayhan Janam on 6/13/18.
//  Copyright © 2018 Rayhan Janam. All rights reserved.
//

import UIKit

class ModalPickerViewController: UIViewController {
    
    var pickerType: PickerType = .date
    var dataSource: [String]?
    
    var pickerData: String?
    
    var onDismiss: ((String) -> Void)?
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var datePickerView: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.isOpaque = false
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.8481475269)
        
        pickerView.isHidden = true
        datePickerView.isHidden = true
        
        switch pickerType {
        case .date:
            datePickerView.isHidden = false
        case .normal:
            pickerView.isHidden = false
            pickerView.dataSource = self
            pickerView.delegate = self
            pickerView(pickerView, didSelectRow: 0, inComponent: 0)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        if let onDismiss = onDismiss {
            switch pickerType {
            case .normal:
                if pickerData != nil {
                    onDismiss(pickerData!)
                }
            case .date:
                onDismiss(DateFormatter.localizedString(from: datePickerView.date, dateStyle: .medium, timeStyle: .none))
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
}

extension ModalPickerViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource?[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerData = dataSource?[row]
    }
}






















