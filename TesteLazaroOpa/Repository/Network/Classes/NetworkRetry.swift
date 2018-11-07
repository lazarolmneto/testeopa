//
//  NetworkRetry.swift
//
//  Created by Lacir Moraes Neto, Lazaro on 08/06/18.
//

import UIKit

public struct NetworkRetry {
    var retryCount: Int
    var delayTime: Double
    var statusCode: Int
    var inverseStatusCode: Bool
    
    init(retryCount: Int, delayTime: Double, statusCode: Int, inverseStatusCode: Bool = false) {
        self.retryCount = retryCount
        self.delayTime = delayTime
        self.statusCode = statusCode
        self.inverseStatusCode = inverseStatusCode
    }
}
