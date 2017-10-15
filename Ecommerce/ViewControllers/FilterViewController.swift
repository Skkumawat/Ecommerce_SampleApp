//
//  FilterViewController.swift
//  Ecommerce
//
//  Created by Sharvan Kumawat on 14/10/17.
//  Copyright © 2017 Sharvan. All rights reserved.
//


import UIKit
import SwiftRangeSlider

protocol FilterDelegate {
    func filterProduct()
}

class FilterViewController: UIViewController, shopTypeDelegate {

    @IBOutlet weak var lblMinimumValue: UILabel!
    @IBOutlet weak var lblMaxmimumValue: UILabel!
    @IBOutlet weak var sliderPriceChange: RangeSlider!
    @IBOutlet weak var shopTypeSelectedView: UIView!
    @IBOutlet weak var wholeSale: UISwitch!
    
     var delegate: FilterDelegate?
    
    var shopTypeSelectedArray = [String]()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sliderPriceChange.trackTintColor = UIColor.gray
        sliderPriceChange.trackHighlightTintColor =  UIColor(red: 71/255, green: 178/255, blue: 79/255, alpha: 1.0)
        
        sliderPriceChange.trackThickness = 0.2
        
        let closeImage   = UIImage(named: "close_icon")!
        
        let closeButton = UIBarButtonItem(image: closeImage,  style: .plain, target: self, action: #selector(self.closeButtonClick(_:)))
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 20))
        label.font = UIFont(name: "Arial", size: 17)
        label.text = "Filter"
        label.textAlignment = .center
        label.textColor = UIColor.gray
        label.backgroundColor =   UIColor.clear
        
        let barButton = UIBarButtonItem(customView: label)
        
        navigationItem.leftBarButtonItems = [closeButton, barButton]
       
        wholeSale.isOn = false
        sliderPriceChange.minimumValue = Utility.minmumValue
        sliderPriceChange.maximumValue = Utility.maxmiumValue
        sliderPriceChange.lowerValue = Utility.minmumValue
        sliderPriceChange.upperValue = Utility.maxmiumValue
        self.perform(#selector(loadData), with: nil, afterDelay: 0.2)
        // Do any additional setup after loading the view.
    }
    
    func loadData(){
        if let obj = DataManager.getSelectedShopType(key: "SavedShopTypeArray"){
            shopTypeSelectedArray = obj
        
            self.perform(#selector(drawShopTypeView), with: nil, afterDelay: 0.0)
            
        }
        if let obj = DataManager.getWholeSale(key: "WholeSales"){
            wholeSale.isOn = obj
        }
        if let minimumPrice = DataManager.getMinMaxPriceOfItem(key: "MinimumPrice")
        {
            lblMinimumValue.text = "Rp " + "\(minimumPrice)"
            sliderPriceChange.lowerValue = minimumPrice
        }
        if let maximumPrice = DataManager.getMinMaxPriceOfItem(key: "MaximumPrice"){
             lblMaxmimumValue.text = "Rp " + "\(maximumPrice)"
            
             sliderPriceChange.upperValue = maximumPrice
        }
    }
    
    @IBAction func closeButtonClick(_ sender: UIButton){
        self.dismiss(animated: true) {
            
        }
    }
    
    @IBAction func resetShopType(_ sender: UIBarButtonItem){
       
        wholeSale.isOn = false
        
        self.shopTypeSelectedArray.removeAll()
        
        sliderPriceChange.lowerValue = Utility.minmumValue
        sliderPriceChange.upperValue = Utility.maxmiumValue
        
        
        setMaxMinLableValue(lowerValue: Int(sliderPriceChange.lowerValue), upperVlaue: Int(sliderPriceChange.upperValue))
    
        self.perform(#selector(drawShopTypeView), with: nil, afterDelay: 0.0)
    }
    
    func setMaxMinLableValue(lowerValue: Int, upperVlaue: Int){
        
        lblMinimumValue.text = "Rp " + "\(lowerValue)"
        
        lblMaxmimumValue.text = "Rp " + "\(upperVlaue)"
    }
    
    @IBAction func rangeSliderValuesChanged(_ rangeSlider: RangeSlider) {
        print("\(rangeSlider.lowerValue), \(rangeSlider.upperValue)")
        
        setMaxMinLableValue(lowerValue: Int(rangeSlider.lowerValue), upperVlaue: Int(rangeSlider.upperValue))
    }
    
    @IBAction func gotoShopType(_ sender: UIButton){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ShopTypeViewController") as! ShopTypeViewController
        controller.delegate = self
        controller.shopTypeSelectedArray = shopTypeSelectedArray
        let navController = UINavigationController(rootViewController: controller)
         self.present(navController, animated:true, completion: nil)

    }
    
    @IBAction func applyButtonClick(_ sender: UIButton){
        
        self.dismiss(animated: true) {
            self.SaveDataInUserdefaults()
            self.delegate?.filterProduct()
        }
    }
    
    func selectedShopType(_ shopTypes: [String]){
        
        shopTypeSelectedArray = shopTypes
        drawShopTypeView()
    }
    
    func drawShopTypeView() {
        
        for view in shopTypeSelectedView.subviews{
            if view.tag != 1000 && view.tag != 1001{
                view.removeFromSuperview()
            }
        }
        
        var x = 10
        var y = 60
        var index = 0
        
        for shopType in shopTypeSelectedArray {
            let label = UILabel(frame: CGRect(x: x, y: y, width: 135, height: 30))
            label.font = UIFont(name: "Arial", size: 12)
            label.text = "  " + shopType
            label.textAlignment = .left
            label.textColor = UIColor.gray
            label.backgroundColor =   UIColor.clear
            label.layer.cornerRadius = 15.0
            label.layer.borderWidth = 1.0
            label.layer.borderColor = UIColor.gray.cgColor
            
            
            let button:UIButton = UIButton(frame: CGRect(x: x + 106, y: y + 1, width: 28, height: 28))
            button.backgroundColor = UIColor.clear
            button.tag = index
            button.setImage(UIImage(named: "Crossrounded_icon"), for: .normal)
            button.addTarget(self, action:#selector(self.buttonRemoveShopTypeClicked), for: .touchUpInside)
            
            shopTypeSelectedView.addSubview(button)

            shopTypeSelectedView.addSubview(label)

            let space = Int(self.view.frame.size.width) - x
            
            if space < 150 {
                x = 10
                y = y + 40
            }
            else{
                x = x + 140
            }
            index += 1
        }
        var frame = self.shopTypeSelectedView.frame
        frame.size.height = self.shopTypeSelectedArray.count == 0 ? 60 : CGFloat(y + 40)
        self.shopTypeSelectedView.frame = frame
       
    }
    func buttonRemoveShopTypeClicked(_ sender: UIButton) {
         let name = shopTypeSelectedArray[sender.tag]
        if let index = shopTypeSelectedArray.index(of:name) {
            shopTypeSelectedArray.remove(at: index)
        }
        drawShopTypeView()
    }
    
    @IBAction func wholeSaleONOFF(_ sender: UISwitch){
        wholeSale.isOn = sender.isOn
    }
    
    func SaveDataInUserdefaults(){
        DataManager.setSelectedShopType(key: "SavedShopTypeArray", value: self.shopTypeSelectedArray)
        
        DataManager.setWholeSale(key: "WholeSales", value: wholeSale.isOn)
        
        DataManager.setMinMaxPriceOfItem(key: "MinimumPrice", value: sliderPriceChange.lowerValue)
        DataManager.setMinMaxPriceOfItem(key: "MaximumPrice", value: sliderPriceChange.upperValue)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
