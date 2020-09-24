//
//  Country.swift
//  Gallery
//
//  Created by CY on 2020/09/24.
//  Copyright © 2020 CY. All rights reserved.
//

import Foundation

struct Country {
    
    var name: String

    var dictionary:[String:Any] {
        return [
            "name": name
        ]
    }
}

