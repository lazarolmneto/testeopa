//
//  Product.swift
//  TesteLazaroOpa
//
//  Created by Lazaro Neto on 05/11/2018.
//  Copyright © 2018 opateste. All rights reserved.
//

import UIKit

class Product: NSObject, Codable {

    var id: Int?
    var image: String?
    var name: String?
    var price: Double?
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case image = "Image"
        case name = "Name"
        case price = "Price"
    }
    
    func toInsertDict() -> [String: Any] {
        var dict = [String: Any]()
        
        dict["Name"] = self.name ?? ""
        dict["Price"] = self.price ?? 0
        
        return dict
    }
}
