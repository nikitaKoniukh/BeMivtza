//
//  SwipeDetailVC.swift
//  discount-project
//
//  Created by Nikita Koniukh on 04/06/2019.
//  Copyright © 2019 Nikita Koniukh. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import MessageUI



private enum State {
    case closed
    case open
}

extension State {
    var opposite: State {
        switch self {
        case .open: return .closed
        case .closed: return .open
        }
    }
}

class SwipeDetailVC: UIViewController, MFMailComposeViewControllerDelegate {
    private let popupOffset: CGFloat = 440
    
    @IBOutlet weak var constraintIB: NSLayoutConstraint!
    @IBOutlet weak var arrowUp: UIImageView!
    @IBOutlet weak var arrowDown: UIImageView!

    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet var collectionView: [UIView]!
    @IBOutlet var collectionLabels: [UILabel]!
    @IBOutlet weak var directionButton: UIButton!
    
    @IBOutlet weak var swipeView: UIView!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var storeLabel: UILabel!
    @IBOutlet weak var rateDetail: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!


    deinit {
        print("deinit")
    }
    //Variables
    var product: ProductModel!
    var userDefaults = UserDefaults.standard
    var productsIds = [String]()
    var counter: Int = 0
    
    
    var starsNumber: Int = 0
    var rateIds = [String]()
    
    // MARK: - View Controller Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.9960784314, green: 0.6980392157, blue: 0.03921568627, alpha: 1)
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9960784314, green: 0.6980392157, blue: 0.03921568627, alpha: 1)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        //set clear color for navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assert(product != nil)

        checkStoredDataForProduct()
        spinner.isHidden = false
        spinner.startAnimating()
        
        //set product
        self.title = product.name
        priceLabel.text = "₪\(product.price ?? 0)"
        storeLabel.text = product.storeName
        dateLabel.text = FormateDateInstance.instance.formateDate(timeStamp: product.timeStamp)
        userNameLabel.text = product.userName
        
        //load image
        if let productImageUrl = product.imageUrl {
            let url = URL(string: productImageUrl)
            URLSession.shared.dataTask(with: url!) { (data, response, error) in
                if let error = error{
                    debugPrint(error)
                }else{
                    DispatchQueue.global(qos: .background).async {
                        DispatchQueue.main.async {
                            
                            UIView.animate(withDuration: 0.3, animations: {
                                self.backgroundImage.alpha = 1
                                self.backgroundImage?.image = UIImage(data: data!)
                                self.spinner.isHidden = true
                                self.spinner.stopAnimating()
                            })
                        }
                    }
                }
            }.resume()
        }
    }
    
    fileprivate func checkStoredDataForProduct() {
        if userDefaults.array(forKey: "productsId")?.count == nil {
            print("no id")
        } else {
            productsIds = userDefaults.array(forKey: "productsId") as! [String]
            print(productsIds)
        }

        if userDefaults.array(forKey: "rateIds")?.count == nil {
            print("no rate id")
        } else {
            rateIds = userDefaults.array(forKey: "rateIds") as! [String]
            print(rateIds)
        }

        if rateIds.contains(product.documentId) {
            rateDetail.setImage(UIImage(named: "star_filled"), for: .normal)
        }
    }

    
    @IBAction func dislikeButtonWasTapped(_ sender: UIButton) {
        checkDoubleClickDisslike()
    }
    
    fileprivate func checkDoubleClickDisslike() {
        if productsIds.contains(product.documentId) {
            let alert = UIAlertController(title: LocalizableEnum.Global.thanks.localized,
                                          message: LocalizableEnum.SwipeDetail.alreadySendFeedback.localized,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: LocalizableEnum.Global.ok.localized,
                                          style: .cancel,
                                          handler: { (_) in
                self.navigationController?.popViewController(animated: true)
            }))
            present(alert, animated: true, completion: nil)
            print("already pressed dislike!")
        } else {
            guard let productId = product.documentId else { return }
            productsIds.append(productId)
            userDefaults.set(productsIds, forKey: "productsId")
            showDisslikeAlert()
        }
    }
    
    fileprivate func showDisslikeAlert() {
        let alert = UIAlertController(title: LocalizableEnum.SwipeDetail.smthWrongAlertTitle.localized,
                                      message: LocalizableEnum.SwipeDetail.sendEmailAlertMessage.localized,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: LocalizableEnum.SwipeDetail.noRelevantAlready.localized,
                                      style: .default,
                                      handler: { (_) in
            self.sendNoRelevantEmail()
        }))
        alert.addAction(UIAlertAction(title: LocalizableEnum.SwipeDetail.postNotValid.localized,
                                      style: .destructive,
                                      handler: { (_) in
            self.sendIllegalEmail()
        }))
        alert.addAction(UIAlertAction(title: LocalizableEnum.Global.cancel.localized,
                                      style: .cancel,
                                      handler: nil))
        
        self.present(alert, animated: true)
    }
    
    fileprivate func deletePost() {
        counter = product.disLikeCounter
        counter += 1
        
        //add disslike to db
        Firestore.firestore()
            .collection(PRODUCT_LIST_REF)
            .document(product.documentId)
            .updateData([DIS_LIKE_COUNTER : counter])
        //check and delete post
        if product.disLikeCounter > 1{
            
            Firestore.firestore().collection(PRODUCT_LIST_REF)
                .document(product.documentId)
                .delete()
            print("dis like!!!!!!!!!!!!!!!")
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    func sendIllegalEmail() {
        if MFMailComposeViewController.canSendMail() {
            guard let id = product.documentId else {return}
            guard let name = product.name else {return}
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["discountproject2019@gmail.com"])
            mail.setSubject("Message from BeMivtza App")
            mail.setMessageBody("<p>This product is a illegal! <br><strong>product id</strong>: \(id), <br><strong>product name</strong>: \(name)</p> ", isHTML: true)
            
            present(mail, animated: true)
        } else {
            print("cant send email")
        }
    }
    
    func sendNoRelevantEmail() {
        if MFMailComposeViewController.canSendMail() {
            guard let id = product.documentId else {return}
            guard let name = product.name else {return}
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["discountproject2019@gmail.com"])
            mail.setSubject("Message from BeMivtza App")
            mail.setMessageBody("<p>This post already no relevant! <br><strong>product id</strong>: \(id), <br><strong>product name</strong>: \(name)</p> ", isHTML: true)
            
            present(mail, animated: true)
        } else {
            print("cant send email")
        }
    }
    
    
    
    //MARK: - MFMail compose method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
        
        let alert = UIAlertController(title: LocalizableEnum.SwipeDetail.thanksForFeedbackAlertTitle.localized,
                                      message: LocalizableEnum.SwipeDetail.enjoyAppAlertMessage.localized,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: LocalizableEnum.Global.ok.localized,
                                      style: UIAlertAction.Style.default,
                                      handler: nil))
        self.present(alert, animated: true, completion: nil)
        self.deletePost()
    }
    
    
    
    @IBAction func dirrectionButtonWasTapped(_ sender: UIButton) {
        
        guard let latitude = product.latitude else {return}
        guard let longitude = product.longitude else {return}
        print(latitude, longitude)
        
        let regionDistance: CLLocationDistance = 1000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion.init(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        
        let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
                       MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
        let placemark = MKPlacemark(coordinate: coordinates)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = product.storeName
        mapItem.openInMaps(launchOptions: options)
        
    }
    
    
    @IBAction func rateTapped(_ sender: UIButton) {
        
        if rateIds.contains(product.documentId) {
            rateIds.removeAll { $0 == product.documentId }
            userDefaults.set(rateIds, forKey: "rateIds")
            
            Firestore.firestore()
                .collection(PRODUCT_LIST_REF)
                .document(product.documentId)
                .setData([NUM_LIKES: product.numLikes - 1], merge: true) { (error) in
                    self.rateDetail.imageView?.image = #imageLiteral(resourceName: "star")
            }
            
        } else {
        rateIds.append(product.documentId)
        userDefaults.set(rateIds, forKey: "rateIds")

        Firestore.firestore()
            .collection(PRODUCT_LIST_REF)
            .document(product.documentId)
            .setData([NUM_LIKES: product.numLikes + 1], merge: true) { (error) in
                self.rateDetail.imageView?.image = #imageLiteral(resourceName: "star_filled")
            }
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

 

    
    
    @IBAction func pan(_ sender: UIPanGestureRecognizer){
        switch sender.state {
        case .began:
            
            // start the animations
            animateTransitionIfNeeded(to: currentState.opposite, duration: 1)
            
            // pause all animations, since the next event may be a pan changed
            runningAnimators.forEach { $0.pauseAnimation() }
            
            // keep track of each animator's progress
            animationProgress = runningAnimators.map { $0.fractionComplete }
            
        case .changed:
            
            // variable setup
            let translation = sender.translation(in: swipeView)
            var fraction = -translation.y / popupOffset
            
            // adjust the fraction for the current state and reversed state
            if currentState == .open { fraction *= -1 }
            if runningAnimators[0].isReversed { fraction *= -1 }
            
            // apply the new fraction
            for (index, animator) in runningAnimators.enumerated() {
                animator.fractionComplete = fraction + animationProgress[index]
            }
            
        case .ended:
            
            // variable setup
            let yVelocity = sender.velocity(in: swipeView).y
            let shouldClose = yVelocity > 0
            
            // if there is no motion, continue all animations and exit early
            if yVelocity == 0 {
                runningAnimators.forEach { $0.continueAnimation(withTimingParameters: nil, durationFactor: 0) }
                break
            }
            
            // reverse the animations based on their current state and pan motion
            switch currentState {
            case .open:
                if !shouldClose && !runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
                if shouldClose && runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
            case .closed:
                if shouldClose && !runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
                if !shouldClose && runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
            }
            
            // continue all animations
            runningAnimators.forEach { $0.continueAnimation(withTimingParameters: nil, durationFactor: 0) }
            
        default:
            ()
        }
    }

    private var currentState: State = .closed

    private var runningAnimators = [UIViewPropertyAnimator]()

    private var animationProgress = [CGFloat]()

    private func animateTransitionIfNeeded(to state: State, duration: TimeInterval) {

    guard runningAnimators.isEmpty else { return }
        
        // an animator for the transition
        let transitionAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1, animations: {
            switch state {
            case .open:
                self.constraintIB.constant = 500
                
                self.swipeView.layer.cornerRadius = 20
                self.swipeView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                self.backgroundImage.alpha = 0.3
                
                for i in self.collectionView{
                    i.alpha = 1
                }
                self.directionButton.alpha = 1
                for i in self.collectionLabels{
                    i.alpha = 1
                }
                
                self.arrowUp.transform = CGAffineTransform(scaleX: 1.2, y: 1.2).concatenating(CGAffineTransform(translationX: 0, y: 15))
                self.arrowDown.transform = .identity
            case .closed:
                
                for i in self.collectionView {
                    i.alpha = 0
                }
                self.directionButton.alpha = 0
                for i in self.collectionLabels {
                    i.alpha = 0
                }
                
                self.constraintIB.constant = 150
                self.swipeView.layer.cornerRadius = 0
                self.backgroundImage.alpha = 1
                self.arrowUp.transform = .identity
                self.arrowDown.transform = CGAffineTransform(scaleX: 1.2, y: 1.2).concatenating(CGAffineTransform(translationX: 0, y: -15))
            }
            self.view.layoutIfNeeded()
        })
        
        // the transition completion block
        transitionAnimator.addCompletion { position in
            
            // update the state
            switch position {
            case .start:
                self.currentState = state.opposite
            case .end:
                self.currentState = state
            case .current:
                ()
            @unknown default:
                fatalError()
            }
            
            // manually reset the constraint positions
            switch self.currentState {
            case .open:
                self.constraintIB.constant = 500
            case .closed:
                self.constraintIB.constant = 150
            }
            
            // remove all running animators
            self.runningAnimators.removeAll()
            
        }
        
        // an animator for the title that is transitioning into view
        let inTitleAnimator = UIViewPropertyAnimator(duration: duration, curve: .easeIn, animations: {
            switch state {
            case .open:
                self.arrowDown.alpha = 1
            case .closed:
                self.arrowUp.alpha = 1
            }
        })
        inTitleAnimator.scrubsLinearly = false
        
        // an animator for the title that is transitioning out of view
        let outTitleAnimator = UIViewPropertyAnimator(duration: duration, curve: .easeOut, animations: {
            switch state {
            case .open:
                self.arrowUp.alpha = 0
            case .closed:
                self.arrowDown.alpha = 0
            }
        })
        outTitleAnimator.scrubsLinearly = false
        
        // start all animators
        transitionAnimator.startAnimation()
        inTitleAnimator.startAnimation()
        outTitleAnimator.startAnimation()
        
        // keep track of all running animators
        runningAnimators.append(transitionAnimator)
        runningAnimators.append(inTitleAnimator)
        runningAnimators.append(outTitleAnimator)
        
    }
}
