//
//  Utility.swift
//  Ecommerce
//
//  Created by Sharvan Kumawat on 14/10/17.
//  Copyright © 2017 Sharvan. All rights reserved.
//


import Foundation
import UIKit
import SystemConfiguration

class Utility: NSObject {
    
    static let enterComment  = "Enter comments!"
    
    static let minmumValue: Double  = 100
    static let maxmiumValue: Double  = 8000000

    
    static let networkError  = "Internet connection not Available!"
    
    static let APIURL  = "https://ace.tokopedia.com/search/v2.5/product?"

    
    class func removeWhitespaceFromString(text: String) -> Bool {
        let trimmedString = text.trimmingCharacters(in: .whitespaces)
        if trimmedString.characters.count > 0 {
            return true
        }
        else{
            return false
        }
    }
    class func checkNetworkStatus() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        
        return (isReachable && !needsConnection)
    }
    
    class func isConnectedToNetwork(view: UIViewController) -> Bool{
        
        if self.checkNetworkStatus() == false{
            let alertController = UIAlertController(title: "", message: networkError, preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            view.present(alertController, animated: true, completion: nil)
            return false
        }
        return true
    }

    
    class func showAlert(title: String, message: String, view: UIViewController){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        
        view.present(alertController, animated: true, completion: nil)
    }
}
