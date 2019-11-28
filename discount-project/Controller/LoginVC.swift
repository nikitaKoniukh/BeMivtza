//
//  LoginVC.swift
//  discount-project
//
//  Created by Nikita Koniukh on 05/05/2019.
//  Copyright © 2019 Nikita Koniukh. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import GoogleSignIn
import FBSDKLoginKit

class LoginVC: UIViewController, GIDSignInDelegate {
    
    //Outlets
    @IBOutlet weak var emailTextFiel: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var createUserButton: UIButton!
    
    @IBOutlet weak var customGoogleLoginButton: UIView!
    @IBOutlet weak var customFacebookLoginButton: UIView!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    //Variables
    let loginManager = LoginManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
        
        customButtonView(customView: customGoogleLoginButton)
        customButtonView(customView: customFacebookLoginButton)
        
        customButton(customButton: loginButton)
        customButton(customButton: createUserButton)
        
        customTextField(customText: emailTextFiel)
        customTextField(customText: passwordTextField)
        
        spinner.isHidden = true
        
        self.hideKeyboardWhenTappedAround()


    }
    
    func customButton(customButton: UIButton){
        customButton.layer.cornerRadius = 5
        customButton.layer.borderWidth = 0.2
        customButton.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        customButton.layer.shadowColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        customButton.layer.shadowRadius = 3
        customButton.layer.shadowOpacity = 1
        customButton.layer.shadowOffset = CGSize(width: 2, height: 2)
    }
    
    func customButtonView(customView: UIView){
        customView.layer.borderWidth = 0.2
        customView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        customView.layer.shadowColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        customView.layer.shadowRadius = 3
        customView.layer.shadowOpacity = 1
        customView.layer.shadowOffset = CGSize(width: 2, height: 2)
    }
    
    func customTextField(customText: UITextField){
        customText.layer.cornerRadius = 5
        customText.layer.borderWidth = 0.2
        customText.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        customText.layer.shadowColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        customText.setLeftPaddingPoints(10)
        customText.setRightPaddingPoints(10)
        
    }
    
    
    //MARK:- Facebook login
    
    @IBAction func facebookTapGesture(_ sender: UITapGestureRecognizer) {
        spinner.isHidden = false
        spinner.startAnimating()
        loginManager.logIn(permissions: ["email"], from: self) { (result, error) in
            if let error = error{
                debugPrint("Couldn't log facebook \(error)")
            }else if result!.isCancelled{
                print("facebook login was canceled")
                self.spinner.isHidden = true
                self.spinner.stopAnimating()
            }else{
                guard let tokenString = AccessToken.current?.tokenString else { return }
                let credential = FacebookAuthProvider.credential(withAccessToken: tokenString)
                self.firebaseLogin(credential)
                self.spinner.isHidden = true
                self.spinner.stopAnimating()
                
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    
    //MARK:- Google login
    
    @IBAction func googleTapGesture(_ sender: UITapGestureRecognizer) {
        spinner.isHidden = false
        spinner.startAnimating()
        GIDSignIn.sharedInstance()?.signIn()
    }
    

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
         if (error == nil) {
             // Perform any operations on signed in user here.
             // ...
           } else {
             print("\(error.localizedDescription)")
           }
    }
    
    func firebaseLogin(_ credential: AuthCredential){
        
        Auth.auth().signInAndRetrieveData(with: credential) { (user, error) in
            if let error = error{
                debugPrint("google auth error: \(error)")
                return
            }else{
                let user = Auth.auth().currentUser
                guard let userId = user?.uid else {return}
                
                let docRef = Firestore.firestore()
                    .collection(USERS_REF)
                    .whereField(USER_ID, isEqualTo: userId).limit(to: 1)
                
                docRef.getDocuments { (querysnapshot, error) in
                    if error != nil {
                        print("Document Error: ", error!)
                    } else {
                        if let doc = querysnapshot?.documents, !doc.isEmpty {
                            print("Document is present.")
                            self.dismiss(animated: true, completion: nil)
                            self.spinner.isHidden = true
                            self.spinner.stopAnimating()
                            self.dismiss(animated: true, completion: nil)
                        }else{
                            
                            Firestore.firestore()
                                .collection(USERS_REF)
                                .addDocument(data:[
                                    USER_ID : userId,
                                    USERNAME : user?.displayName ?? "",
                                    DATE_CREATED : FieldValue.serverTimestamp()
                                ]) { (error) in
                                    if let error = error{
                                        debugPrint(error.localizedDescription)
                                        
                                    }else{
                                        self.dismiss(animated: true, completion: nil)
                                        self.spinner.isHidden = true
                                        self.spinner.stopAnimating()
                                    }
                            }
                        }
                    }
                }
            }
        }
    }
    
    //MARK:- Email login
    
    @IBAction func loginButtonWasTapped(_ sender: Any) {
        guard let email = emailTextFiel.text,
            let password = passwordTextField.text else {return}
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error{
                debugPrint("Error login in: \(error)")
            }else{
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    @IBAction func closeButtonWasTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
extension  UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

extension LoginVC {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginVC.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        
    }
}

