//
//  CreateUserVC.swift
//  discount-project
//
//  Created by Nikita Koniukh on 05/05/2019.
//  Copyright © 2019 Nikita Koniukh. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class CreateUserVC: UIViewController {
    
    //Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var createUserButton: RoundedButton!
    @IBOutlet weak var cancelButton: RoundedButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func createUserButtonWasTapped(_ sender: Any) {
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            let username = userNameTextField.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error{
                debugPrint("Error creating user: \(error)")
            }else{
                let changeRequest = authResult?.user.createProfileChangeRequest()
                changeRequest?.displayName = username
                changeRequest?.commitChanges(completion: { (error) in
                    if let error = error{
                        debugPrint(error.localizedDescription)
                    }else{
                        let user = Auth.auth().currentUser
                        guard let userId = user?.uid else {return}
                        
                        Firestore.firestore()
                            .collection(USERS_REF)
                            .addDocument(data:[
                                USER_ID : userId,
                                USERNAME : username,
                                //IS_ADMIN: false,
                                DATE_CREATED : FieldValue.serverTimestamp()
                            ]) { (error) in
                                if let error = error{
                                    debugPrint(error.localizedDescription)
                                }else{
                                    self.dismiss(animated: true, completion: nil)
                                }
                        }
                    }
                })
            }
        }
    }
    
    
    @IBAction func canselButtonWasTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func closeButtonWasTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
