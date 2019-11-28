//
//  AddImageVC.swift
//  discount-project
//
//  Created by Nikita Koniukh on 14/05/2019.
//  Copyright © 2019 Nikita Koniukh. All rights reserved.
//

import UIKit
import CoreML
import Vision
import Firebase

class FinishAddingProduct: UIViewController {
    

    //Outlets
    @IBOutlet weak var addImage: UIImageView!
    @IBOutlet weak var categorySegmentControl: UISegmentedControl!
    @IBOutlet weak var addProductName: UITextField!
    @IBOutlet weak var addPrice: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    //Variables:
    var selectedCategory = ProductCategory.food.rawValue
    var tempImage: UIImage?
    var tempName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addProductName.text = tempName
        addImage.image = tempImage
        
        self.hideKeyboardWhenTappedAround()

    }
    
    
    
    
    @IBAction func categoryChanged(_ sender: UISegmentedControl) {
        switch categorySegmentControl.selectedSegmentIndex {
        case 0 :
            selectedCategory = ProductCategory.food.rawValue
        case 1 :
            selectedCategory = ProductCategory.clothing.rawValue
        case 2 :
            selectedCategory = ProductCategory.cosmetics.rawValue
        case 3 :
            selectedCategory = ProductCategory.electronics.rawValue
        default:
            selectedCategory = ProductCategory.food.rawValue
        }
    }
    
    func registerProductIntoDataBase(url: String){
        let user = Auth.auth().currentUser
        Firestore.firestore()
            .collection(PRODUCT_LIST_REF)
            .addDocument(data: [
                CATEGORY_NAME : selectedCategory,
                NUM_LIKES: 0,
                PRODUCT_NAME: addProductName.text ?? "",
                TIME_STAMP: FieldValue.serverTimestamp(),
                PRODUCT_PRICE: Int(addPrice.text ?? "") ?? 000,
                STORE_LOCATION: "",
                USERNAME: user?.displayName ?? "",
                PRODUCT_IMAGE_URL: url
            ]) { (err) in
                if let err = err{
                    debugPrint("Error adding document\(err)")
                }else{
                    
                    
                    
                    self.tabBarController?.selectedIndex = 0
                    let navController = self.tabBarController?.selectedViewController as! UINavigationController
                    self.navigationController?.popViewController(animated: true)
                    navController.popToRootViewController(animated: true)
                    self.spinner.isHidden = true
                    self.spinner.stopAnimating()
                }
        }
    }
    
    @IBAction func doneButtonWasTapped(_ sender: UIBarButtonItem) {
        
        if addProductName.text != ""{
            
            spinner.isHidden = false
            spinner.startAnimating()
           // doneButton.isEnabled = false
            
            
            let storage = Storage.storage()
            
            let imageName = NSUUID().uuidString
            let storageRef = storage.reference().child(imageName)
            
            guard let uploadData = addImage.image!.jpegData(compressionQuality: 0.1) else {return}
            
            storageRef.putData(uploadData, metadata: nil) { (_, error) in
                if let error = error{
                    debugPrint("Error: \(error)")
                }else{
                    storageRef.downloadURL(completion: { (url, err) in
                        if let err = err {
                            debugPrint(err)
                            return
                        }
                        guard let url = url else { return }
                        self.registerProductIntoDataBase(url: url.absoluteString)
                    })
                }
            }
        }
    }
//
//    //MARK: - keyboard
//    @objc func keyboardWillChange(notification: Notification){
//
//        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {return}
//
//        if notification.name == UIResponder.keyboardWillChangeFrameNotification ||
//            notification.name == UIResponder.keyboardWillShowNotification{
//            view.frame.origin.y = -keyboardRect.height + ((navigationController?.navigationBar.frame.height)!)
//        }else{
//            view.frame.origin.y =  ((navigationController?.navigationBar.frame.height)!)
//        }
//
//    }
//
//    deinit {
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
//    }

}

// dissmis keyboard
extension FinishAddingProduct {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(FinishAddingProduct.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
       // view.frame.origin.y = ((navigationController?.navigationBar.frame.height)!)
    }
}
