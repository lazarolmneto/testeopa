//
//  UIImage+NetworkManager.swift
//
//  Created by Lacir Moraes Neto, Lazaro on 08/06/18.
//

import UIKit

extension UIImage {
    
    public static func loadImage(url: String, completion: @escaping (_ image: UIImage?)->Void) {
        NetworkManager.shared.request(url: url, requestMethod: .get, cacheType: .alwaysCache) { (response) in
            DispatchQueue.main.async {
                switch response.result {
                case .success(let value):
                    print("success")
                    if let data = value as? Data {
                        completion(UIImage(data: data))
                    } else {
                        completion(nil)
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
