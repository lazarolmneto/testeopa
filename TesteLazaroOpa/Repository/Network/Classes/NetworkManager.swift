//
//  NetworkManager.swift
//
//  Created by Lacir Moraes Neto, Lazaro on 19/04/18.
//

import UIKit

open class NetworkManager: NSObject {

    //MARK: Variable
    fileprivate var session         : URLSession!
    fileprivate var timeOutRequest  : Double?
    fileprivate var timeOutResource : Double?
    fileprivate var clousures       : [StatusCodeClousure]!
    
    fileprivate var useCache = false
    
    var certificates    : [Data]?
    
    open static var shared : NetworkManager = NetworkManager()
    
    //MARK: Lifecycle
    fileprivate override init() {
        super.init()
        self.session    = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        self.clousures  = [StatusCodeClousure]()
    }
    
    //MARK: Methods
    
    //Add methods for a specific status code
    public func addClousureToStatusCode(statusCode: Int, clousure: @escaping ((NetworkResponse, @escaping (NetworkResponse)->Void)->Void)) {
        
        for i in 0..<self.clousures.count{
            if self.clousures[i].code == statusCode {
                self.clousures.remove(at: i)
            }
        }
        
        self.clousures.append(StatusCodeClousure(code: statusCode, clousure: clousure))
    }
    
    //Remove clousure from status code
    public func removeClousureFromStatusCode(statusCode: Int) {
        self.clousures = self.clousures.filter({ (clousure) -> Bool in
            return clousure.code != statusCode
        })
    }
    
    //Set the certificates for security
    public func setPinningCertificates(certificates: [Data]?) {
        self.certificates = certificates
    }
    
    //Add cache if necessary
    public func addCache(_ memoryCapacity: Int? = nil, _ diskCapacity: Int? = nil, _ diskPath: String? = nil) {
        
        let configuration = self.session.configuration
        configuration.timeoutIntervalForRequest =  self.timeOutRequest ?? Double(60)// seconds
        configuration.timeoutIntervalForResource =  self.timeOutResource ?? Double(60 * 24 * 7)
        
        let memoryCapacity = memoryCapacity ?? (20 * 1024 * 1024)
        let diskCapacity   = diskCapacity ?? (20 * 1024 * 1024)
        
        configuration.urlCache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: diskPath)
        configuration.requestCachePolicy = .useProtocolCachePolicy
        
        self.session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }
    
    //Do Request
    public func request(url: String,
                        requestMethod : NetworkMethod? = nil,
                        header: [String : Any]? = nil,
                        parameters: Any? = nil,
                        timeOut: Double? = nil,
                        headerEncoding : NetworkHeaderEncoding? = nil,
                        cacheType: NetworkCacheType = .noCache,
                        networkRetry: NetworkRetry? = nil,
                        completion: @escaping (NetworkResponse)->Void) {
     
        if let url = URL(string: url) {
            var request = URLRequest(url: url)
            
            if cacheType != .noCache && !self.useCache {
                self.addCache()
                self.useCache = true
            }
            
            let timeOut = self.timeOutRequest ?? Double(60)
            
            var cachePolicy: URLRequest.CachePolicy
            
            switch cacheType {
            case .noCache:
                cachePolicy = .reloadIgnoringCacheData
            case .alwaysCache:
                cachePolicy = .returnCacheDataElseLoad
            case .cacheOnlyIfOffline:
                cachePolicy = Reachability.isConnectedToNetwork() ? URLRequest.CachePolicy.reloadIgnoringLocalCacheData : URLRequest.CachePolicy.returnCacheDataDontLoad
            }

            request = URLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: timeOut)
            
            let requestMethodT = requestMethod?.rawValue ?? NetworkMethod.get.rawValue
            
            if let header = header{
                for (key, value) in header{
                    if let value = value as? String{
                        request.addValue(value, forHTTPHeaderField: key)
                    }
                }
            }
            
            if let headerEncoding = headerEncoding{
                request.addValue(headerEncoding.rawValue, forHTTPHeaderField: "Content-type")
            }
            
            request.httpMethod = requestMethodT
            
            /*
                The parameters is a Any object that can be a dictonary or a string or any type that its necessary for the application and can be customize here
            */
            if let parameters = parameters {
                
                var succededParameters = false
                
                if let dict = parameters as? [String : Any] {
                    let jsonData = try? JSONSerialization.data(withJSONObject: dict)
                    request.httpBody = jsonData
                    if headerEncoding == nil {
                        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    }
                    
                    succededParameters = true
                }
                
                if let dict = parameters as? [[String : Any]] {
                    let jsonData = try? JSONSerialization.data(withJSONObject: dict)
                    request.httpBody = jsonData
                    if headerEncoding == nil {
                        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    }
                    
                    succededParameters = true
                }
                
                if let string = parameters as? String{
                    let myParamsNSData: NSData = string.data(using: String.Encoding.utf8)! as NSData
                    request.httpBody = myParamsNSData as Data
                    if headerEncoding == nil {
                        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                    }
                    
                    succededParameters = true
                }
                
                if !succededParameters{
                    
                    let error = NetworkError(error: "parametros formato invalido", domain: "invalid parameters", code: 10001)
                    
                    let networkResponse = NetworkResponse(request: request, response: nil, value: nil, error: error, statusCode: nil)
//                    DispatchQueue.main.async {
//                        completion(networkResponse)
//                    }
                    DispatchQueue.global().async {
                        completion(networkResponse)
                    }

                    return
                }
            }
            
            self.sendTask(request: request, networkRetry: networkRetry, completion: completion)
        }
    }
    
    public func request(request: URLRequest,
                        useCacheRequest: Bool = false,
                        networkRetry: NetworkRetry? = nil,
                        completion: @escaping (NetworkResponse)->Void) {
        
        if useCacheRequest && !self.useCache {
            self.addCache()
            self.useCache = true
        }
        
        self.sendTask(request: request, networkRetry: networkRetry, completion: completion)
    }
    
    private func sendTask(request: URLRequest,
                          networkRetry: NetworkRetry? = nil,
                          completion: @escaping (NetworkResponse)->Void) {
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? nil
            
            let networkResponse = NetworkResponse(request: request, response: response as? HTTPURLResponse, value: data, error: error, statusCode: statusCode)
                        
            if let statusCode = statusCode {
                for statusClousure in self.clousures {
                    if statusClousure.code == statusCode {
                        
                        statusClousure.clousure(networkResponse, completion)
                        //                            statusClousure.clousure(networkResponse)
                        return
                    }
                }
            }
            
            DispatchQueue.main.async {
                if var networkRetry = networkRetry, networkRetry.retryCount > 1,
                    (networkResponse.statusCode == networkRetry.statusCode && !networkRetry.inverseStatusCode) ||
                        (networkResponse.statusCode != networkRetry.statusCode && networkRetry.inverseStatusCode) {
                    networkRetry.retryCount -= 1
                    self.request(request: request, networkRetry: networkRetry, completion: { (response) in
                        completion(response)
                    })
                } else {
                    completion(networkResponse)
                }
            }
        }
        
        task.resume()
    }
}
