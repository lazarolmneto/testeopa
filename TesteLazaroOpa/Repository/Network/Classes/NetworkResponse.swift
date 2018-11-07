//
//  NetworkResponse.swift
//
//  Created by Lacir Moraes Neto, Lazaro on 08/06/18.
//

import UIKit

public enum EnumResultResponse {
    case success(Any)
    case failure(Any?, Error)
}

public struct NetworkResponse{
    
    //MARK: - Variables
    public var request     : URLRequest!
    public var response    : URLResponse?
    public var result      : EnumResultResponse
    public var statusCode  : Int?
    
    //MARK: - convert data in types
    public var JSON : Any? {
        get {
            switch result {
            case .success(let value):
                if let data = value as? Data, let jsonSerialization = try? JSONSerialization.jsonObject(with: data, options: []) {
                    return jsonSerialization
                }
                return nil
            case .failure(let value, _):
                if let data = value as? Data, let jsonSerialization = try? JSONSerialization.jsonObject(with: data, options: []) {
                    return jsonSerialization
                }
                return nil
            }
        }
    }
    
    public func stringValue(type: String.Encoding) -> String? {
        
        switch result {
        case .success(let value):
            print(value)
            if let value = value as? Data {
                return String(data: value, encoding: type)
            }
            return nil
        case .failure(let value, _):
            if let value = value as? Data {
                return String(data: value, encoding: type)
            }
            return nil
        }
    }
    
    init(request: URLRequest, response: HTTPURLResponse? = nil, value: Any? = nil, error: Error? = nil, statusCode: Int? = nil) {
        self.request    = request
        self.response   = response
        
        if let error = error {
            self.result = EnumResultResponse.failure(value, error)
        } else {
            if let value = value{
                self.result = EnumResultResponse.success(value)
            } else {
                let error = NSError(domain: "Unknow", code: -1, userInfo: [NSLocalizedDescriptionKey: "Could not get the error of the request"])
                self.result = EnumResultResponse.failure(value, error)
            }
        }
        
        self.statusCode = statusCode
    }
}
