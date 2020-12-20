//
//  NetworkManager.swift
//  Networking
//
//  Created by Александр Майко on 25.10.2020.
//  Copyright © 2020 Александр Майко. All rights reserved.
//

import UIKit

class NetworkManager {

    static func getRequest(url: String) {
        guard let url = URL(string: url) else
        { return }
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            guard let response = response, let data = data else { return }
//            print(response)
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            } catch {
                print(error)
            }
        } .resume()
        

    }
    
    static func postRequest(url: String) {
        guard let url = URL(string: url) else
        { return }
        let userData = ["course" : "Networking" , "lesson" : "Get and POST Requests"]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: userData, options: []) else { return }
        request.httpBody = httpBody
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") // здесь мы указываем в каком формате приходит json
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            guard let response = response , let data = data else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
//                print(response)
            } catch {
                print(error)
            }
        }.resume()
    }
    static func downloadImage(url: String, completion: @escaping (_ image: UIImage)->()) {
        guard let url = URL(string: url) else { return }
        let session = URLSession.shared
        
        session.dataTask(with: url) { (data, response, error) in
            if let data = data, let image1 = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image1)
    

                }
            }
        } .resume()
    }
    
    static func fetchData(url: String, completion : @escaping(_ courses1: [Course])->()) {
        guard let url = URL(string: url) else { return }
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            print(data)
            do {
                let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                let courses2 = try decoder.decode([Course].self, from: data)
                completion(courses2)
               
            } catch {
                print("ПОПАЛИ В ОШИБКУ!!!!!!!!!!!!!!!!!!!!")
            }
        }.resume()
    }
        
        
    static func uploadImage(url: String) {
        let headers = ["Authorization" : "Client-ID d3ae45ae271e67f"]
        let image = UIImage(named: "Untitled")!
        guard let imageProperties = ImageProperties(withImage: image, for: "image") else { return }// "image" указан на сайте как необходимое имя ключа
        guard let url = URL(string: url) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = imageProperties.data
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                } catch {
                    print (error)
                }
            }
        }.resume()
        
    }
}

