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
    
    func createGeneriErrorForResponse() -> Error {
        let error = NSError(domain: "network", code: -1, userInfo: [NSLocalizedDescriptionKey: "Não foi possível completar operação, tente novamente mais tarde"])
        return error
    }
}
