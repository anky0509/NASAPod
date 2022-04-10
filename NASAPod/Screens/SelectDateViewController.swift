//
//  ViewController.swift
//  NASAPod
//
//  Created by Ankita Porwal on 09/04/22.
//

import UIKit

class SelectDateViewController: UIViewController {
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var dateTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dateTextField.datePicker(target: self, doneAction: #selector(doneAction), cancelAction: #selector(cancelAction))
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Picture Of the Day"
    }
    
    private func setupView() {
        dateTextLabel.text = "Select date"
    }
    
    @objc
    func cancelAction() {
        self.dateTextField.resignFirstResponder()
    }
    
    @objc
    func doneAction() {
        if let datePickerView = self.dateTextField.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.string(from: datePickerView.date)
            dateTextField.text = dateString
            dateTextField.resignFirstResponder()
        }
    }
    
    @IBAction func submitButtonAction(_ sender: Any) {
        if let text = dateTextField.text, text != "" {
            let pictureVC = PictureViewController.fromStoryboard()
            pictureVC.selectedDate = text
            navigationController?.pushViewController(pictureVC, animated: true)
        }
    }
}

