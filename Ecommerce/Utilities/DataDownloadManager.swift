//
//  DataDownloadManager.swift
//  Ecommerce
//
//  Created by Sharvan Kumawat on 14/10/17.
//  Copyright © 2017 Sharvan. All rights reserved.
//


import UIKit

class DataDownloadManager: NSObject {
    
    class func getProductsList(pageNo:Int, PageRow: Int, completion: @escaping(_ result: [ProductDetail]) -> Void) {
        
        // Set up the URL request
        let q = "samsung"
        var pmin = 100
        var pmax = 8000000
        var wholesale = false
        var official = false
        var fshop = 0
        
        if let minimumPrice = DataManager.getMinMaxPriceOfItem(key: "MinimumPrice")
        {
            pmin = Int(minimumPrice)
        }
        if let maximumPrice = DataManager.getMinMaxPriceOfItem(key: "MaximumPrice"){
            pmax = Int(maximumPrice)
        }
        if let obj = DataManager.getWholeSale(key: "WholeSales"){
            wholesale = obj
        }
        
        if let obj = DataManager.getSelectedShopType(key: "SavedShopTypeArray"){
            print(obj)
            if obj.contains("Officle Store"){
                official = true
            }
            if obj.contains("Gold Merchant"){
                fshop = 2
            }
        }
        
        let endpoint: String = Utility.APIURL + "q=\(q)&pmin=\(pmin)&pmax=\(pmax)&wholesale=\(wholesale)&official=\(official)&fshop=\(fshop)&start=\(pageNo)&rows=\(PageRow)"
        
        print("endpoint===\(endpoint)")
        guard let url = URL(string: endpoint) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = URLRequest(url: url)
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                print("error calling GET on products list")
                print(error.debugDescription)
                return
            }
            
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            // parse the result as JSON
            do {
                guard let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: AnyObject] else {
                    print("error trying to convert data to JSON")
                    return
                }
                
                var finalProducts = [ProductDetail]()
                if let products = json["data"] as? [[String: AnyObject]] {
                    
                    for product in products {
                        
                        let p = ProductDetail()
                        p.name = product["name"] as? String ?? ""
                        p.imageUrl = product["image_uri"] as? String ?? ""
                        p.price = product["price"] as? String ?? ""
                        finalProducts.append(p)
                    }
                }
                
                completion(finalProducts)
                
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
        
        task.resume()
    }
}
extension UIImageView {
    public func imageFromServerURL(urlString: String) {
        
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
            
        }).resume()
    }}

