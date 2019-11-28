//
//  FinishAddingProduct.swift
//  discount-project
//
//  Created by Nikita Koniukh on 14/05/2019.
//  Copyright © 2019 Nikita Koniukh. All rights reserved.
//

import UIKit
import CoreML
import Vision
import Firebase
import MapKit
import Contacts



class FinishAddingProduct: UIViewController, UITextFieldDelegate {
    
    //Outlets
    @IBOutlet weak var addImage: UIImageView!
    @IBOutlet weak var categorySegmentControl: UISegmentedControl!
    @IBOutlet weak var addProductName: UITextField!
    @IBOutlet weak var addPrice: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var addLocationButton: RoundedButton!
    @IBOutlet weak var storeAddressTextField: UITextField!
    @IBOutlet weak var storeNameTextField: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    @IBOutlet weak var adressStack: UIStackView!
    @IBOutlet weak var storeNameStack: UIStackView!
    
    
    
    //Variables:
    var selectedCategory = ProductCategory.food.rawValue
    var tempImage: UIImage?
    var tempName: String?
    var longitude: Double?
    var latitude: Double?
    var storeNameVar: String?
    var storeAddressVar: String?

    private let localize = LocalizableEnum.finishAddingProduct.self
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addProductName.text = tempName
        addImage.image = tempImage
        
        self.hideKeyboardWhenTappedAround()
        self.navigationItem.titleView = LogoSmall.instance.setLogo()
        addPrice.delegate = self
        addProductName.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    //max count of the textField
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
        guard let textField = textField.text else {return false}

        let count = textField.count + string.count - range.length
        if textField == addPrice.text {
            return count <= 6
        } else if textField == addProductName.text {
            return count <= 30
        }
        return true
    }
    
    fileprivate func getStoreLocatio() {
        let searchLocationVC = storyboard!.instantiateViewController(withIdentifier: "searchLocationVC") as! SearchLocationVC
        searchLocationVC.getNameDelegate = self
        searchLocationVC.getCoordinatesDelegate = self
        navigationController?.pushViewController(searchLocationVC, animated: true)
        
        self.adressStack.isHidden = false
        self.storeNameStack.isHidden = false
    }
    
    @IBAction func addLocationButtonWasTapped(_ sender: Any) {
        getStoreLocatio()
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
        guard let lat = latitude else {return}
        guard let lon = longitude else {return}
        
        let user = Auth.auth().currentUser
        print("user name: \(String(describing: user?.displayName))")
        Firestore.firestore()
            .collection(PRODUCT_LIST_REF)
            .addDocument(data: [
                CATEGORY_NAME : selectedCategory,
                NUM_LIKES: 0,
                PRODUCT_NAME: addProductName.text ?? "",
                TIME_STAMP: FieldValue.serverTimestamp(),
                PRODUCT_PRICE: Double(addPrice.text ?? "") ?? 000,
                STORE_LOCATION: GeoPoint.init(latitude: lat, longitude: lon),
                USERNAME: user?.displayName ?? "" as Any,
                PRODUCT_IMAGE_URL: url,
                STORE_NAME: storeNameVar ?? "store name",
                STORE_ADDRESS: storeAddressVar ?? "store address",
                DIS_LIKE_COUNTER: 0
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
        
        if addPrice.text == "0" || addPrice.text == "0.0"{
            let alert = UIAlertController(title: LocalizableEnum.Global.oops.localized, message: localize.noZeroPrice.localized, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: LocalizableEnum.Global.ok.localized, style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            
        
        
        if storeNameTextField.text == "" && storeAddressTextField.text == ""{
            spinner.isHidden = true
            spinner.stopAnimating()
            
            let alert = UIAlertController(title: LocalizableEnum.Global.oops.localized, message: "בחר מיקום של החנות", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: LocalizableEnum.Global.ok.localized, style: .default, handler: { (_) in
                self.getStoreLocatio()
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
        if addProductName.text != "" && addPrice.text != "" && storeNameStack.isHidden == false && adressStack.isHidden == false{
            
            spinner.isHidden = false
            spinner.startAnimating()
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            
            
            let storage = Storage.storage()
            
            let imageName = NSUUID().uuidString
            let storageRef = storage.reference().child(imageName)
            
            guard let uploadData = addImage.image!.jpegData(compressionQuality: 0.1) else {return}
            
            storageRef.putData(uploadData, metadata: nil) { (_, error) in
                if let error = error{
                    debugPrint("Error: \(error)")
                    
                    self.spinner.isHidden = true
                    self.spinner.stopAnimating()
                    
                    let alert = UIAlertController(title: LocalizableEnum.Global.oops.localized, message: "היכנס לחשבון שלך", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "בטל", style: .cancel, handler: { (_) in
                        self.navigationController?.popViewController(animated: true)
                    }))
                    alert.addAction(UIAlertAction(title: "Login", style: .default, handler: { (_) in
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let loginVc = storyBoard.instantiateViewController(withIdentifier: "loginVC")
                        self.present(loginVc, animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }else{
                    
                    self.navigationItem.rightBarButtonItem?.isEnabled = false
                    
                    storageRef.downloadURL(completion: { (url, err) in
                        if let err = err {
                            debugPrint(err)
                            return
                        }
                        guard let url = url else { return }
                        //self.proregisterProductIntoDataBase(url: url.absoluteString)
                    })
                }
            }
        }else{
            
            if storeNameStack.isHidden == true && adressStack.isHidden == true {
                
                let alert = UIAlertController(title: LocalizableEnum.Global.oops.localized, message: "בחר מיקום של החנות", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: LocalizableEnum.Global.ok.localized, style: .default, handler: { (_) in
                    self.getStoreLocatio()
                }))
                self.present(alert, animated: true, completion: nil)
            }else{
                 CustomAlert(title: localize.noEmptyFields.localized).show(animated: true)
            }
        }
    }
    }
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

extension FinishAddingProduct: GetNameStoreDelegate{
    func getStoreNameAndAddress(storeName: String, storeAddress: String) {
        storeNameTextField.text = storeName
        storeAddressTextField.text = storeAddress
        storeNameVar = storeName
        storeAddressVar = storeAddress
        
    }
}

extension FinishAddingProduct: getCoordinatesDelegate{
    func getCoordinates(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    
}
