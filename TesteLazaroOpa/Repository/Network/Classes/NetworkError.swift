//
//  NetworkError.swift
//
//  Created by Lacir Moraes Neto, Lazaro on 08/06/18.
//

import UIKit

open class NetworkError: NSError {
    
    init(error: String, domain: String = "", code: Int = -1) {
        super.init(domain: domain, code: code, userInfo: [NSLocalizedDescriptionKey: error])
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
