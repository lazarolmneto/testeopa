//
//  ProductsTableViewController.swift
//  TesteLazaroOpa
//
//  Created by Lazaro Neto on 06/11/2018.
//  Copyright © 2018 opateste. All rights reserved.
//

import UIKit

protocol ProductsFavoritesTableViewProtocol {
    func favorite(product: Product)
}

protocol ProductsUpdateTableViewProtocol {
    func updateList()
}

class ProductsTableViewController: UITableViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBAction func btSave(_ sender: Any) {
    }
    
    var products = [Product]()
    
    var alreadyLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.createRefreshControl()
        self.getList()
    }
    
    func createRefreshControl() {
        
        let refresh = UIRefreshControl()
        
        refresh.addTarget(self, action: #selector(self.getList), for: .valueChanged)
        refresh.tintColor = UIColor.black
        
        self.refreshControl = refresh
//        self.tableView.addSubview(self.refreshControl)
    }

    @objc func getList() {
        sharedWebService.getProducts { (success, products, error) in
            self.alreadyLoaded = true
            if let products = products, success {
                self.products = products
            }
            
            DispatchQueue.main.async {
                self.refreshControl?.endRefreshing()
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.segmentedControl.selectedSegmentIndex == 0 {
            if alreadyLoaded && self.products.isEmpty{
                return 1
            }
            
            return self.products.count
        } else {
            return LocalData.getFavorites()?.count ?? 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if self.segmentedControl.selectedSegmentIndex == 0 {
            if alreadyLoaded && self.products.isEmpty{
                let cell = tableView.dequeueReusableCell(withIdentifier: "emptyListCell", for: indexPath)
                
                return cell
            }
            
            
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as! ProductTableViewCell
        
        if self.segmentedControl.selectedSegmentIndex == 0 {
            cell.product = self.products[indexPath.row]
        } else {
            if let product = LocalData.getFavorites()?[indexPath.row] {
                cell.product = product
            }
        }
        
        cell.listDelegate = self
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if alreadyLoaded && self.products.isEmpty{
            return 140
        }
        return 80
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func didTapOnSwitch(_ sender: UISegmentedControl) {
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? InsertProductViewController {
            destination.updateDelegate = self
        }
    }
}

extension ProductsTableViewController: ProductsFavoritesTableViewProtocol {
    
    func favorite(product: Product) {
        
        if let _ = LocalData.findById(product: product) {
            //remove
            LocalData.removeFavorite(favorite: product)
        } else {
            //add
            LocalData.addFavorite(favorite: product)
        }
        
        self.tableView.reloadData()
    }
}

extension ProductsTableViewController: ProductsUpdateTableViewProtocol {
    
    func updateList() {
        DispatchQueue.main.async {
            self.getList()
        }        
    }
}
