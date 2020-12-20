//
//  ImageProperties.swift
//  Networking
//
//  Created by Александр Майко on 25.10.2020.
//  Copyright © 2020 Александр Майко. All rights reserved.
//

import UIKit


struct ImageProperties {
    let key: String
    let data: Data
    
    init?(withImage image: UIImage, for key: String) {
        self.key = key
        guard let data = image.pngData() else { return nil }
        self.data = data
    }
}
