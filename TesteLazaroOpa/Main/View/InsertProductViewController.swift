//
//  InsertProductViewController.swift
//  TesteLazaroOpa
//
//  Created by Lazaro Neto on 07/11/2018.
//  Copyright © 2018 opateste. All rights reserved.
//

import UIKit

class InsertProductViewController: UIViewController {

    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var textPrice: UITextField!
    @IBOutlet weak var btSave: UIBarButtonItem!
    
    var updateDelegate: ProductsUpdateTableViewProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func didTapOnInsert(_ sender: Any) {
        
        if validate() {
            let product = Product()
            product.name = self.textName.text
            product.price = Double(textPrice.text!)
            
            self.btSave.isEnabled = false
        
            let activity = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            activity.startAnimating()
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activity)
            sharedWebService.insertProduct(product: product) { (success, product, error) in
                self.btSave.isEnabled = true

                if let _ = product, success {
                    self.navigationController?.popViewController(animated: true)
                    self.updateDelegate?.updateList()
                } else {
                    self.navigationItem.rightBarButtonItem = self.btSave
                    if let error = error {
                        self.genericAlert(message: error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func validate() -> Bool {
        
        if let textName = self.textName.text, textName.trimmingCharacters(in: .whitespaces).isEmpty {
            self.genericAlert(message: "Preencha campo nome")
            return false
        }
        
        if let textPrice = self.textPrice.text, Double(textPrice) == nil {
            self.genericAlert(message: "Preço preenchido incorretamente")
            return false
        }
        
        return true
    }
    
    func genericAlert(message: String) {
        let alert = UIAlertController(title: "Opa!", message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
}
