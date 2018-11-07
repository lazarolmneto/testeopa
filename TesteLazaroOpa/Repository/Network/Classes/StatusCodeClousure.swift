//
//  StatusCodeClousure.swift
//
//  Created by Lacir Moraes Neto, Lazaro on 08/06/18.
//

import UIKit

public struct StatusCodeClousure {
    var code: Int
    var clousure: (NetworkResponse, @escaping (NetworkResponse)->Void) -> Void
    
    init(code: Int, clousure: @escaping (NetworkResponse, @escaping ((NetworkResponse)->Void))->Void) {
        self.code = code
        self.clousure = clousure
    }
}
