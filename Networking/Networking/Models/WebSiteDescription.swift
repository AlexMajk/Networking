//
//  WebSiteDescription.swift
//  Networking
//
//  Created by Александр Майко on 11.10.2020.
//  Copyright © 2020 Александр Майко. All rights reserved.
//

import Foundation

struct WebSiteDescription: Decodable{
    
    let websiteDescription: String
    let websiteName: String
    let courses:[Course]
}
