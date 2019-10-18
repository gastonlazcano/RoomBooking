//
//  LoginViewController.swift
//  RoomBooking
//
//  Created by Daira Bezzato on 24/09/2019.
//  Copyright © 2019 Globant. All rights reserved.
//

import UIKit

protocol LoginDelegate {
   func loginCompleted()
}

class LoginViewController: UIViewController, LoginDelegate {
    
    let googleManager = GoogleCalendarManager.shared
    
    func loginCompleted() {
        performSegue(withIdentifier: "showHome", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        googleManager.loginDelegate = self
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        googleManager.auth(viewController: self)
        //googleManager.loadState()
    }

}

extension UIViewController {
    // Helper for showing an alert
    func showAlert(title : String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertController.Style.alert
        )
        let ok = UIAlertAction(
            title: "OK",
            style: UIAlertAction.Style.default,
            handler: nil
        )
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
}
