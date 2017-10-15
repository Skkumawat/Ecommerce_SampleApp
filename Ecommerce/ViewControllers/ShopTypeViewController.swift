//
//  ShopTypeViewController.swift
//  Ecommerce
//
//  Created by Sharvan Kumawat on 14/10/17.
//  Copyright © 2017 Sharvan. All rights reserved.
//


import UIKit

protocol shopTypeDelegate {
    func selectedShopType(_ shopTypes: [String])
}

class ShopTypeViewController: UIViewController {
    
    @IBOutlet weak var tblShopType: UITableView!
    
    var shopTypeArray = ["Gold Merchant", "Officle Store"]
    
    var shopTypeSelectedArray = [String]()
    
    var delegate: shopTypeDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let closeImage   = UIImage(named: "close_icon")!
        
        let closeButton = UIBarButtonItem(image: closeImage,  style: .plain, target: self, action: #selector(self.closeButtonClick(_:)))
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        label.font = UIFont(name: "Arial", size: 17)
        label.text = "Shop Type"
        label.textAlignment = .center
        label.textColor = UIColor.gray
        label.backgroundColor =   UIColor.clear
        
        let barButton = UIBarButtonItem(customView: label)
        
        navigationItem.leftBarButtonItems = [closeButton, barButton]
        
        tblShopType.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    @IBAction func closeButtonClick(_ sender: UIButton){
        self.dismiss(animated: true) {
            
        }
    }
    
    @IBAction func resetShopType(_ sender: UIBarButtonItem){
        shopTypeSelectedArray.removeAll()
        tblShopType.reloadData()
    }
    
    @IBAction func applyButtonClick(_ sender: UIButton){
        self.dismiss(animated: false) {
             self.delegate?.selectedShopType(self.shopTypeSelectedArray)
        }

    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension ShopTypeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shopTypeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShopTypeCell", for: indexPath) as! ShopTypeCell
        
        let name = shopTypeArray[indexPath.row]
        cell.lblShopName?.text = name
        cell.imgView?.image = shopTypeSelectedArray.contains(name) ? UIImage(named: "Check") : UIImage(named: "UnCheck")
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! ShopTypeCell
        let name = shopTypeArray[indexPath.row]
        if shopTypeSelectedArray.contains(name) {
            if let index = shopTypeSelectedArray.index(of:name) {
                shopTypeSelectedArray.remove(at: index)
            }
            cell.imgView.image = UIImage(named: "UnCheck")
        }
        else{
            shopTypeSelectedArray.append(name)
            cell.imgView.image = UIImage(named: "Check")
        }
        
    }
}

