//
//  ProductCVCell.swift
//  Ecommerce
//
//  Created by Sharvan Kumawat on 14/10/17.
//  Copyright © 2017 Sharvan. All rights reserved.
//


import Foundation
import UIKit

class ProductCVCell: UICollectionViewCell {
    
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productImage: UIImageView!

    func configureCell(withProduct product:ProductDetail) {
        if let pName = product.name {
            self.productName.text = pName
        }
        
        if let pImageUrl = product.imageUrl
        {
            // Add the code to fetch product image
            // We can also add default image like placeholder image
            
            productImage.imageFromServerURL(urlString: pImageUrl)
        }
        if let pPrice = product.price {
            productPrice.text = pPrice
        }
    }
    override func prepareForReuse()
    {
        super.prepareForReuse()
        // Reset the cell for new row's data
        self.productName.text = ""
        self.productPrice.text = ""
        self.productImage.image = nil
    }
}
