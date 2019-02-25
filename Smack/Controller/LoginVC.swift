//
//  LoginVC.swift
//  Smack
//
//  Created by Дмитрий Болоников on 11/20/18.
//  Copyright © 2018 Дмитрий Болоников. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    //Outlets
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var warningLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        spinner.isHidden = false
        spinner.startAnimating()
        
        guard let email = usernameText.text, usernameText.text != "" else { return }
        guard let password = passwordText.text, passwordText.text != "" else { return }
        
        AuthService.instance.loginUser(email: email, password: password) { (success) in
            if success {
                AuthService.instance.findUserByEmail(completion: { (success) in
                    if success {
                        NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                        self.warningLabel.isHidden = true
                        self.spinner.isHidden = true
                        self.spinner.stopAnimating()
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        self.incorrentData()
                    }
                })
            } else {
                self.incorrentData()
            }
        }
    }
    
    func incorrentData() {
        //UserDataService.instance.logoutUser()
        //NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        AuthService.instance.isLoggedIn = false
        self.warningLabel.isHidden = false
        self.usernameText.text = ""
        self.passwordText.text = ""
        self.spinner.isHidden = true
        self.spinner.stopAnimating()
    }
    
    @IBAction func closePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createAccountButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_CREATE_ACCOUNT, sender: nil)
    }
    
    func setupView() {
        warningLabel.isHidden = true
        spinner.isHidden = true
        usernameText.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSAttributedStringKey.foregroundColor: smackPurplePlaceholder])
        passwordText.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedStringKey.foregroundColor: smackPurplePlaceholder])
    }
    
}
