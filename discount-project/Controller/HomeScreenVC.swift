//
//  HomeScreenVC.swift
//  discount-project
//
//  Created by Nikita Koniukh on 01/05/2019.
//  Copyright © 2019 Nikita Koniukh. All rights reserved.
//

import UIKit
import Firebase
import Reachability

class HomeScreenVC: UIViewController {
    //Variables
    private var products = [ProductModel]()
    private var productsCollectionRef: CollectionReference!
    private var productListener: ListenerRegistration!
    private var selectedCategory = ProductCategory.popular.rawValue
    private var handle: AuthStateDidChangeListenerHandle?
    let reachability = Reachability()
    let product = ProductsService()
    let cellId = "discountCell"
    let detailSegue = "toDetail"

    let localize = LocalizableEnum.HomeScreen.self

    //Outlets
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        selectedCategory = ProductCategory.popular.rawValue
        productsCollectionRef = Firestore.firestore().collection(PRODUCT_LIST_REF)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setReachabilityNotifire()
        setListener()
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.1411563158, green: 0.1411880553, blue: 0.1411542892, alpha: 1)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        productListener.remove()
    }

    func setListener() {
        if selectedCategory == ProductCategory.popular.rawValue {
            productListener =  productsCollectionRef
                .order(by: NUM_LIKES, descending: true)
                .addSnapshotListener { (snapshot, error) in
                    if let error = error{
                        debugPrint("Error fetching docs: \(error)")
                    } else {
                        DispatchQueue.main.async {
                            self.products.removeAll()
                            self.products = self.product.parseData(snapshot: snapshot)
                            self.tableView.reloadData()
                        }
                    }
                }
        } else {
            productListener =  productsCollectionRef
                .whereField(CATEGORY_NAME, isEqualTo: selectedCategory)
                .order(by: TIME_STAMP, descending: true)
                .addSnapshotListener { (snapshot, error) in
                    if let error = error{
                        debugPrint("Error fetching docs: \(error)")
                    } else {
                        DispatchQueue.main.async {
                            self.products.removeAll()
                            self.products = self.product.parseData(snapshot: snapshot)
                            self.tableView.reloadData()
                        }
                    }
                }
        }
    }

    func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.clear
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.titleView = LogoSmall.instance.setLogo()
    }

    @IBAction func addCheckinButtonWasPressed(_ sender: UIButton) {
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if user == nil {
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let loginVc = storyBoard.instantiateViewController(withIdentifier: "loginVC")
                self.present(loginVc, animated: true, completion: nil)
            }else{
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let addVc = storyBoard.instantiateViewController(withIdentifier: "addVc")
                self.navigationController?.pushViewController(addVc, animated: true)
            }
        })
    }
    
    @IBAction func categoryChanged(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex{
        case 0 :
            selectedCategory = ProductCategory.popular.rawValue
        case 1 :
            selectedCategory = ProductCategory.food.rawValue
        case 2 :
            selectedCategory = ProductCategory.clothing.rawValue
        case 3 :
            selectedCategory = ProductCategory.cosmetics.rawValue
        case 4 :
            selectedCategory = ProductCategory.electronics.rawValue
        default:
            selectedCategory = ProductCategory.popular.rawValue
        }
        productListener.remove()
        setListener()
    }
    
    @IBAction func profileLoginButtonWasTapped(_ sender: UIBarButtonItem) {
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if user == nil{
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let loginVc = storyBoard.instantiateViewController(withIdentifier: "loginVC")
                self.present(loginVc, animated: true, completion: nil)
            }else{
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let profileVc = storyBoard.instantiateViewController(withIdentifier: "profileVc")
                self.present(profileVc, animated: true, completion: nil)
            }
        })
    }
    
    //MARK: - check internet connection
    func setReachabilityNotifire() {
        NotificationCenter.default.addObserver(self, selector: #selector(reachabiluityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do {
            try reachability?.startNotifier()
        } catch {
            debugPrint("coul'd start reachability notifire")
        }
    }
    
    @objc func reachabiluityChanged(note: Notification) {
        let reachability = note.object as! Reachability
        switch reachability.connection {
        case .wifi:
            print("wifi!!!!!!!!!!!!!!!")
        case .cellular:
            print("celular!!!!!!!!!!!!!!!")
        case .none:
            print("no!!!!!!!!!!!!!!!")
            CustomAlert(title: localize.noInternetConnection.localized).show(animated: true)
        }
    }

    //MARK: - Deleting Product
    // delete image frome the storage
    func deleteImageFromTheStorage(at indexPath: IndexPath) {
        let storage = Storage.storage()
        guard let childsImageURL = self.products[indexPath.row].imageUrl else {return}

        let storageRef = storage.reference(forURL: childsImageURL)

        storageRef.delete { error in
            if let error = error {
                debugPrint(error.localizedDescription)
            } else {
                debugPrint("File deleted successfully")
            }
        }
    }

    // delete document from firestore
    func deleteDocumentFromTheFirestore(at indexPath: IndexPath) {
        guard let docId = self.products[indexPath.row].documentId else { return }
        let collectionReference = Firestore.firestore().collection(PRODUCT_LIST_REF).document(docId)
        collectionReference.delete()
    }
}

extension HomeScreenVC {
    func alert (message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: LocalizableEnum.Global.ok.localized, style: .default, handler: nil)
        alertController.addAction(okAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

extension HomeScreenVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? DiscountCell {
            cell.configureCell(product: products[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard let user = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        db.collection(USERS_REF).whereField(USER_ID, isEqualTo: user)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    debugPrint("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        
                        //check isAdmin
                        guard let isAdmin = document.data()["isAdmin"] as? Int else { return }
                        if isAdmin == 1{

                            self.deleteImageFromTheStorage(at: indexPath)
                            self.deleteDocumentFromTheFirestore(at: indexPath)

                            //delete from table view
                            self.products.remove(at: indexPath.row)
                            tableView.deleteRows(at: [indexPath], with: .fade)

                        } else {
                            let alert = UIAlertController(title: LocalizableEnum.Global.oops.localized, message: self.localize.noPermissionToDellete.localized, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: LocalizableEnum.Global.ok.localized, style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
        }
    }
    
    private func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = products[indexPath.row]
        performSegue(withIdentifier: detailSegue, sender: product)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = localize.headerText.localized
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.products.count > 0 ? 0 : 500
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? SwipeDetailVC else {return}
        destination.product = sender as? ProductModel
        
        //set text for back item
        let backItem = UIBarButtonItem()
        backItem.title = localize.backBtn.localized
        navigationItem.backBarButtonItem = backItem
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

