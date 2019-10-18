//
//  ProfileViewController.swift
//  RoomBooking
//
//  Created by Daira Bezzato on 26/09/2019.
//  Copyright © 2019 Globant. All rights reserved.
//

import UIKit
import AlamofireImage

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profilePictureImage: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var profileViewModel: ProfileViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewModel()
        viewModel = profileViewModel
    }
    
    var viewModel: ProfileViewModel! {
        didSet {
            emailLabel.text = "\(viewModel.user.email)"
            fullNameLabel.text = "\(viewModel.user.fullName)"
            let url = URL(string: viewModel.user.profileImage)
            profilePictureImage.af_setImage(withURL: url!)
        }
    }
    
    @IBAction func didTapSignOut(_ sender: AnyObject) {
        self.showAlert(title: "404 Not Found", message: "Sorry This is not implemented yet, try agaim im the next commit")
        //UserDefaultManager().deleteUserDefault() //I will implement this in the future
    }
    
    func setViewModel() {
        let defaults = UserDefaults.standard
        guard let profileVC = defaults.object(forKey: "profileViewModel") as? Data else {
            return
        }
        
        // Use PropertyListDecoder to convert Data into ProfileViewModel
        guard let profileViewModelDecoded = try? PropertyListDecoder().decode(ProfileViewModel.self, from: profileVC) else {
            return
        }
        self.profileViewModel = profileViewModelDecoded
    }
}
