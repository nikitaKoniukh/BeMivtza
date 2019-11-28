//
//  DiscountCell.swift
//  discount-project
//
//  Created by Nikita Koniukh on 02/05/2019.
//  Copyright © 2019 Nikita Koniukh. All rights reserved.
//

import UIKit
import SDWebImage

class DiscountCell: UITableViewCell {
    
    //Outlets:
    @IBOutlet var imageProductCell: UIImageView!
    @IBOutlet var nameProductCell: UILabel!
    @IBOutlet weak var locationStoreCell: UILabel!
    @IBOutlet weak var priceProductCell: UILabel!
    @IBOutlet weak var raitingCell: UILabel!
    @IBOutlet weak var dateTimeCell: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var cardView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        spinner.isHidden = false
        spinner.startAnimating()

        setupCell()
        setupCardViewCell()
    }
    
    
    func configureCell(product: ProductModel) {
        nameProductCell.text = product.name
        priceProductCell.text = "₪ \(product.price ?? 000)"
        raitingCell.text = "\(product.numLikes ?? 0)"
        locationStoreCell.text = product.storeName

        dateTimeCell.text = product.timeStamp.timestamp
        
        imageProductCell.image = UIImage(named: "image-add-button")
        
        if let productImageUrl = product.imageUrl {
            let url = URL(string: productImageUrl)
            self.imageProductCell.sd_setImage(with: url) { (_, _, _, _) in
                self.spinner.isHidden = true
                self.spinner.stopAnimating()
            }
        }
    }
    
    func setupCell() {
       // imageProductCell?.layer.cornerRadius = 5
        imageProductCell.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        imageProductCell.layer.borderWidth = 0.2
        imageProductCell.layer.cornerRadius = imageProductCell.layer.frame.height / 2
    }

    func setupCardViewCell() {
        cardView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        cardView.layer.cornerRadius = 5
        cardView.layer.masksToBounds = false
        cardView.layer.shadowColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.8470588235)
        cardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        cardView.layer.shadowOpacity = 0.8
    }

}
