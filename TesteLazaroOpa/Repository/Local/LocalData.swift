//
//  LocalData.swift
//  TesteLazaroOpa
//
//  Created by Lazaro Neto on 05/11/2018.
//  Copyright © 2018 opateste. All rights reserved.
//

import UIKit

class LocalData: NSObject {

    class func addFavorite(favorite: Product) {
    
        var products = self.getFavorites() ?? [Product]()
        
        let defauts = UserDefaults.standard

        products.append(favorite)
//        defauts.set(products, forKey: "favorites")
        
        if let data = try? JSONEncoder().encode(products) {
            defauts.set(data, forKey: "favorites")
        } else {
            defauts.set(nil, forKey: "favorites")
        }
        
        defauts.synchronize()
        
    }
    
    class func removeFavorite(favorite: Product) {
        
        var products = self.getFavorites() ?? [Product]()
        
        let defauts = UserDefaults.standard
        
        products = products.filter({ (productF) -> Bool in
            return productF.id != favorite.id
        })
        
        if let data = try? JSONEncoder().encode(products) {
            defauts.set(data, forKey: "favorites")
        } else {
            defauts.set(nil, forKey: "favorites")
        }
        
//        defauts.set(products, forKey: "favorites")
        defauts.synchronize()
        
    }
    
    class func findById(product: Product) -> Product? {
        
        return self.getFavorites()?.filter({ (productF) -> Bool in
            return product.id == productF.id
        }).first
    }
    
    class func getFavorites() -> [Product]? {
        let defauts = UserDefaults.standard
        if let data = defauts.object(forKey: "favorites") as? Data {
            return try? JSONDecoder().decode([Product].self, from: data)
        }
        return nil
    }
    
}
