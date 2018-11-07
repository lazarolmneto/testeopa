//
//  ProductService.swift
//  TesteLazaroOpa
//
//  Created by Lazaro Neto on 05/11/2018.
//  Copyright © 2018 opateste. All rights reserved.
//

import UIKit

extension WebService {
    
    func getProducts(resultResponse: @escaping ResultResponse<[Product]>) {
        
        NetworkManager.shared.request(url: "http://opa-mobiletest.azurewebsites.net/api/Product/Get", requestMethod: .get, header: nil, headerEncoding: NetworkHeaderEncoding.JSON) { (response) in
            print(response)
            switch response.result {
            case .success(let data):
                print(data)
                if let data = data as? Data,
                    let produtcs: [Product] = data.decodeToObject() {
                    print(produtcs)
                    resultResponse(true, produtcs, nil)
                }
            case .failure(_, let error):
                print(error)
                resultResponse(false, nil, error)
            }
        }
    }
    
    func insertProduct(product: Product, resultResponse: @escaping ResultResponse<Product>) {
        NetworkManager.shared.request(url: "http://opa-mobiletest.azurewebsites.net/api/Product/Insert", requestMethod: .post, parameters: product.toInsertDict(), headerEncoding: NetworkHeaderEncoding.JSON) { (response) in
            switch response.result {
            case .success(let data):
                print(data)
                if let data = data as? Data,
                    let produtc: Product = data.decodeToObject() {
                    print(produtc)
                    resultResponse(true, produtc, nil)
                } else {
                    let error = self.createGeneriErrorForResponse()
                    resultResponse(false, nil, error)
                }
            case .failure(_, let error):
                print(error)
                resultResponse(false, nil, error)
            }
        }
    }
}
