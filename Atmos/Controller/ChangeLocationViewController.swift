//
//  ChangeLocationViewController.swift
//  Atmos
//
//  Created by Maulik Sharma on 23/11/18.
//  Copyright © 2018 Geekskool. All rights reserved.
//

import UIKit

//MARK: - Delegate Protocol

protocol ChangeLocationDelegate {
    func didEnterNewLocationName(locationName: String)
}

class ChangeLocationViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: - Outlets
    
    @IBOutlet weak var changeLocationTextField: UITextField!
    
    //MARK: - Delegate
    
    var delegate: ChangeLocationDelegate?
    
    //MARK: - Actions
    
    @IBAction func getWeather(_ sender: UIButton) {
        if let location = changeLocationTextField.text {
            delegate?.didEnterNewLocationName(locationName: location)
            self.dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func dismissView(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - TextField Delegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeLocationTextField.delegate = self
    }
    
}
