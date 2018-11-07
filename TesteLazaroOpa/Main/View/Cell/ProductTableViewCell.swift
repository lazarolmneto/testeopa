//
//  ProductTableViewCell.swift
//  TesteLazaroOpa
//
//  Created by Lazaro Neto on 06/11/2018.
//  Copyright © 2018 opateste. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var btFavorite: UIButton!
    
    var listDelegate: ProductsFavoritesTableViewProtocol?
    
    var product: Product!{
        didSet {
            self.fillLabels()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func fillLabels() {
        self.labelName?.text = self.product.name
        
        if let price = self.product.price {
            let formatter = NumberFormatter()
            formatter.locale = Locale(identifier: "pt_BR")
            formatter.currencyCode = "BRL"
            formatter.numberStyle = .currency
            let numberPrice = NSNumber(value: price)
            self.labelPrice.text = formatter.string(from: numberPrice)
        }
        
        self.btFavorite.setImage(UIImage(named: "favorite_empty"), for: .normal)
        if let _ = LocalData.findById(product: self.product) {
            self.btFavorite.setImage(UIImage(named: "favorite_filled"), for: .normal)
        }
    }
    
    @IBAction func didTapOnFavorite(_ sender: Any) {
        self.listDelegate?.favorite(product: self.product)
    }
}
