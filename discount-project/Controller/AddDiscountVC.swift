//
//  AddDiscountVC.swift
//  discount-project
//
//  Created by Nikita Koniukh on 01/05/2019.
//  Copyright © 2019 Nikita Koniukh. All rights reserved.
//

import UIKit
import CoreML
import Vision
import Firebase

class AddDiscountVC: UIViewController {
    
    //Outlets:
    @IBOutlet private var addImage: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var percentage: UILabel!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    @IBOutlet weak var productNameFrame: UIVisualEffectView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!

    //Variables:
    var selectedCategory = ProductCategory.food.rawValue
    let picker = UIImagePickerController()
    var localized = LocalizableEnum.AddDiscount.self
    
    //let storage = Storage.storage()
    var selectedImageforUpload: UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addImage.image = #imageLiteral(resourceName: "hoach-le-dinh-91879-unsplash")
        setupView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        nextButton.isEnabled = false
        productNameLabel.text = localized.pressCameraBtn.localized
        addImage.image = #imageLiteral(resourceName: "hoach-le-dinh-91879-unsplash")
        percentage.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    func setupView(){
        productNameFrame.addShadow(offset: CGSize(width: 2, height: 2), color: #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1), radius: 10, opacity: 1)
        self.navigationItem.titleView = LogoSmall.instance.setLogo()
    }
    
    @IBAction func nextButtonWasTapped(_ sender: UIBarButtonItem) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "addDetail") as? FinishAddingProduct else {return}
        vc.tempName = productNameLabel.text
        vc.tempImage = selectedImageforUpload
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    @IBAction func cameraButtonWasTapped(_ sender: UIBarButtonItem) {

        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            presentPhotoPicker(sourceType: .photoLibrary)
            return
        }
        let alertController = UIAlertController()
        let takePhotoAction = UIAlertAction(title: localized.takePictureAlert.localized, style: .default) { (_) in

            self.presentPhotoPicker(sourceType: .camera)
        }
        let choosePhotoAction = UIAlertAction(title: localized.selectPhotoAlert.localized, style: .default) { (_) in
            
            self.presentPhotoPicker(sourceType: .photoLibrary)
        }
        alertController.addAction(takePhotoAction)
        alertController.addAction(choosePhotoAction)
        alertController.addAction(UIAlertAction(title: LocalizableEnum.Global.cancel.localized,
                                                style: .cancel,
                                                handler: nil))

        alertController.modalPresentationStyle = .popover
        let ppc = alertController.popoverPresentationController
        ppc?.barButtonItem = self.cameraButton
        present(alertController, animated: true, completion: nil)
    }
    
    func presentPhotoPicker(sourceType: UIImagePickerController.SourceType){
        
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = sourceType
        present(picker, animated: true, completion: nil)
    }
    
    //MARK: - CORE ML
    lazy var classificationRequest: VNCoreMLRequest = {
        do {
            let model = try VNCoreMLModel(for: ImageClassifier().model)
            let request = VNCoreMLRequest(model: model, completionHandler: { (request, error) in
                self.resultMethod(request: request, error: error)
            })
            request.imageCropAndScaleOption = .centerCrop
            return request
            
        }catch{
            fatalError("Fail to load ML\(error)")
        }
    }()
    
    func resultMethod(request: VNRequest, error: Error?){
        guard let results = request.results as? [VNClassificationObservation] else {return}
        
        DispatchQueue.main.async {
            for classification in results{
                if classification.confidence < 0.4{
                    self.productNameLabel.text = "\(classification.identifier)"
                    self.percentage.isHidden = false
                    self.percentage.text = "\(self.localized.confidence.localized) \(Int(classification.confidence * 100))%"
                    self.nextButton.isEnabled = true
                    break
                }else{
                    self.productNameLabel.text = "\(classification.identifier)"
                    self.percentage.isHidden = false
                    self.percentage.text = "\(self.localized.confidence.localized) \(Int(classification.confidence * 100))%"
                    self.nextButton.isEnabled = true
                    break
                }
            }
        }
        
    }
    
    func updateClassifications(for image: UIImage) {
        
        guard let orientation = CGImagePropertyOrientation(rawValue: UInt32(image.imageOrientation.rawValue)), let ciImage = CIImage(image: image) else {
            print("error")
            return
        }
        DispatchQueue.global(qos: .userInteractive).async {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
            do {
                try handler.perform([self.classificationRequest])
            } catch {
                print("Failed to perform classification.\n\(error.localizedDescription)")
            }
        }
    }
}

extension AddDiscountVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {fatalError("No image picked")}
        addImage.image = image
        
        self.selectedImageforUpload = image
        updateClassifications(for: image)
    }
    
    
}
