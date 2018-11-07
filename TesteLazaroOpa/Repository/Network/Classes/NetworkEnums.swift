//
//  NetworkEnums.swift
//
//  Created by Lacir Moraes Neto, Lazaro on 08/06/18.
//

import UIKit

public enum NetworkHeaderEncoding: String{
    case JSON       = "application/json"
    case ULREncoded = "application/x-www-form-urlencoded"
}

public enum NetWorkStatusCode{
    case success
}

public enum NetworkMethod: String{
    case post   = "POST"
    case get    = "GET"
    case put    = "PUT"
    case delete = "DELETE"
    case patch  = "PATCH"
}

public enum NetworkCacheType: Int {
    case noCache = 1
    case alwaysCache = 2
    case cacheOnlyIfOffline = 3
}
