//
//  ProfileVC.swift
//  Smack
//
//  Created by Дмитрий Болоников on 11/28/18.
//  Copyright © 2018 Дмитрий Болоников. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {

    //Outlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var useremail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    @IBAction func closeModalPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        UserDataService.instance.logoutUser()
        NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editUsernamePressed(_ sender: Any) {
        guard let newUsername = username.text, username.text != "" else { return }
        UserDataService.instance.editUsername(newUsername: newUsername) { (success) in
            if success {
                self.username.text = ""
                self.username.attributedPlaceholder = NSAttributedString(string: UserDataService.instance.name, attributes: [NSAttributedStringKey.foregroundColor: smackPurplePlaceholder])
                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
            }
        }
    }
    
    func setupView() {
        username.attributedPlaceholder = NSAttributedString(string: UserDataService.instance.name, attributes: [NSAttributedStringKey.foregroundColor: smackPurplePlaceholder])
        profileImage.image = UIImage(named: UserDataService.instance.avatarName)
        profileImage.backgroundColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
        useremail.text = UserDataService.instance.email
    }
}
