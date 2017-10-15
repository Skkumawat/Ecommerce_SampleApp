//
//  ViewController.swift
//  Ecommerce
//
//  Created by Sharvan Kumawat on 14/10/17.
//  Copyright © 2017 Sharvan. All rights reserved.
//


import UIKit

class ListViewController: UIViewController,FilterDelegate {
    
    @IBOutlet weak var productCollectionView: UICollectionView!
    var products = [ProductDetail]()
    
    var pageNo = 0
    var pageSize = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.perform(#selector(loadProductData), with: nil, afterDelay: 0.2)
    }
    
    func loadProductData(){
        if Utility.isConnectedToNetwork(view: self) == true
        {
           UIApplication.shared.isNetworkActivityIndicatorVisible = true
            DataDownloadManager.getProductsList(pageNo: pageNo, PageRow: 10, completion: { (productDetails) in
                for product in productDetails {
                   self.products.append(product)
                }
                
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.productCollectionView.reloadData()
                }
            })
        }
    }
    
    func filterProduct(){
        pageNo = 0
        pageSize = 10
        products.removeAll()
        loadProductData()
    }
    
    @IBAction func filterButtonClick(_ sender: UIButton){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "FilterViewController") as! FilterViewController
        controller.delegate = self
        let navController = UINavigationController(rootViewController: controller)
        
        self.present(navController, animated:true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCVCell", for: indexPath)
        
        guard let productCell = cell as? ProductCVCell else {
            return cell
        }
        
        if products.count > indexPath.row {
            let product = products[indexPath.row]
            productCell.configureCell(withProduct: product)
        }
        
        return productCell
    }
    
}

extension ListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = (collectionView.frame.size.width - 20)/2
        let cellHeight = (cellWidth * 4)/3
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
}

extension ListViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        print(maximumOffset - currentOffset)
        if maximumOffset - currentOffset <= -60 {
            pageNo = pageNo + 1
            loadProductData()
        }
    }
    
}



