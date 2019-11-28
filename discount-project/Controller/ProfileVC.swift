//
//  ProfileVC.swift
//  discount-project
//
//  Created by Nikita Koniukh on 05/05/2019.
//  Copyright © 2019 Nikita Koniukh. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit

class ProfileVC: UIViewController, GIDSignInDelegate {


    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
         if (error == nil) {
             // Perform any operations on signed in user here.
             // ...
           } else {
             print("\(error.localizedDescription)")
           }
    }

    
    //Outlets
    @IBOutlet weak var userNameLabel: UILabel!
    
    //Variables
    let loginManager = LoginManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.delegate = self
        
        userNameLabel.text = Auth.auth().currentUser?.displayName
        self.navigationItem.titleView = LogoSmall.instance.setLogo()
    }
    
    @IBAction func closeButtonWasTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func logoutButtonWasTapped(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do{
            logoutSocial()
            try firebaseAuth.signOut()
            
            dismiss(animated: true, completion: nil)
        }catch let signOutError as NSError{
            debugPrint("Error signing out: \(signOutError)")
        }
    }
    
    
    func logoutSocial(){
        guard let user = Auth.auth().currentUser else {return}
        
        for info in user.providerData{
            switch info.providerID{
            case GoogleAuthProviderID:
                print("Google")
                GIDSignIn.sharedInstance()?.signOut()
            case FacebookAuthProviderID:
                print("Facebock")
                loginManager.logOut()
            default:
                break
            }
        }
    }
    
    
    
}
