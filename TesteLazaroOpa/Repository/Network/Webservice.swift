//
//  Webservice.swift
//  TesteLazaroOpa
//
//  Created by Lazaro Neto on 05/11/2018.
//  Copyright © 2018 opateste. All rights reserved.
//

import UIKit

typealias ResultResponse<T> = (_ success: Bool, _ value: T?, _ error: Error?)-> Void

let sharedWebService = WebService()

class WebService: NSObject {
    
    fileprivate override init(){}
    
    enum Path {
        
        case getProducts
        case postProduct
        
        var path: String {
            
            switch self {
            case .getProducts:
                return returnUrl(path: "get")
            case .postProduct:
                return returnUrl(path: "post")
            }
        }
        
        private func returnUrl(path: String) -> String {
            if let url = Bundle.main.object(forInfoDictionaryKey: "ServerURL") as? String {
                return url + path
            }
            return ""
        }
    }
    
    func createGeneriErrorForResponse() -> Error {
        let error = NSError(domain: "network", code: -1, userInfo: [NSLocalizedDescriptionKey: "Não foi possível completar operação, tente novamente mais tarde"])
        return error
    }
}
