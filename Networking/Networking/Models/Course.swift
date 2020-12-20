//
//  Courses.swift
//  Networking
//
//  Created by Александр Майко on 29.09.2020.
//  Copyright © 2020 Александр Майко. All rights reserved.
//

import Foundation

/*struct Course: Decodable { вариант для работы без Alamofire
    let id: Int?
    let name: String?
    let link: String?
    let imageUrl: String?
    let numberOfLessons: Int?
    let numberOfTests: Int?
}*/
 
 struct Course: Decodable {
     let id: Int?
     let name: String?
     let link: String?
     let imageUrl: String?
     let numberOfLessons: Int?
     let numberOfTests: Int?
 // !!! здесь мы сделали инициализатор, чтобы при получении массива данных через alamofire (класс AlamofireNetworkManager ) разложить данные по нашему шаблону и затем использовать их, чтобы заполнить coursesTableView
    init?(json:[String: Any]) {
        let id = json["id"] as? Int
        let name = json["name"] as? String
        let link = json["link"] as? String
        let imageUrl = json["imageUrl"] as? String
        let numberOfLessons = json["number_of_lessons"] as? Int
        let numberOfTests = json["number_of_tests"] as? Int
        
        
        self.id = id
        self.name = name
        self.link = link
        self.imageUrl = imageUrl
        self.numberOfLessons = numberOfLessons
        self.numberOfTests = numberOfTests
        
    }
    
    static func getArray(from jsonArray: Any) -> [Course]? {
        guard let jsonArray = jsonArray as? Array<[String: Any]> else { return nil}
        return jsonArray.compactMap { Course(json: $0) }
        }
        // ИЛИ
//        var courses : [Course] = []
//        for jsonObject in jsonArray {
//            if let course = Course(json: jsonObject) {
//                courses.append(course)
//            }
//        }
//        return courses
    }
