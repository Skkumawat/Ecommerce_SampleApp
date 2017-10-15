//
//  ShopTypeCell.swift
//  Ecommerce
//
//  Created by Sharvan Kumawat on 14/10/17.
//  Copyright © 2017 Sharvan. All rights reserved.
//


import UIKit

class ShopTypeCell: UITableViewCell {

    @IBOutlet weak var lblShopName: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func prepareForReuse()
    {
        super.prepareForReuse()
        self.lblShopName.text = ""
        self.imgView.image = UIImage(named: "UnCheck")
    }
}
