//
//  DataManager.swift
//  Ecommerce
//
//  Created by Sharvan Kumawat on 14/10/17.
//  Copyright © 2017 Sharvan. All rights reserved.
//


import UIKit

class DataManager: NSObject {
    
    static let defaults = UserDefaults.standard
    
    class func setSelectedShopType(key: String, value: [String]){
        defaults.set(value, forKey: key)
    }
    
    class func getSelectedShopType(key: String) -> [String]?{
        return defaults.object(forKey: key) as? [String]
    }
    
    class func setWholeSale(key: String, value: Bool){
        defaults.set(value, forKey: key)
    }
    
    class func getWholeSale(key: String) -> Bool?{
        return defaults.object(forKey: key) as? Bool
    }
    
    class func setMinMaxPriceOfItem(key: String, value: Double){
        defaults.set(value, forKey: key)
    }
    
    class func getMinMaxPriceOfItem(key: String) -> Double?{
        return defaults.object(forKey: key) as? Double
    }
}
