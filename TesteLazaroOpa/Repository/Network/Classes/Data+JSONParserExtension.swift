//
//  Data+JSONParserExtension.swift
//
//  Created by Lacir Moraes Neto, Lazaro on 15/06/18.
//

import UIKit

public extension Data {
    
    public func decodeToObject<T: Codable>() -> T? {
        
        if let object = try? JSONDecoder().decode(T.self, from: self) {
            return object
        }
        
        return nil
    }
    
    public func decodeToObject<T: Codable>(from key: String) -> T? {
        
        if let mainDictJson = try? JSONSerialization.jsonObject(with: self, options: .allowFragments),
            let mainDict = mainDictJson as? [String: Any] {
            if let dict = mainDict[key] as? [String: Any] {
                if let json = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted) {
                    if let object = try? JSONDecoder().decode(T.self, from: json) {
                        return object
                    }
                }
            }
            
            if let returnOject = mainDict[key] as? [[String: Any]] {
                if let json = try? JSONSerialization.data(withJSONObject: returnOject, options: .prettyPrinted) {
                    if let object = try? JSONDecoder().decode(T.self, from: json) {
                        return object
                    }
                }
            }
        }
        
        return nil
        
//        if let dict = try? JSONDecoder().decode([String: T].self, from: self) {
//            if let object = dict[key] {
//                return object
//            }
//        }
//
//        return nil
    }
}
