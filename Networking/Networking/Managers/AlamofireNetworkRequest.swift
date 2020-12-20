//
//  AlamofireNetworkRequest.swift
//  Networking
//
//  Created by Александр Майко on 08.11.2020.
//  Copyright © 2020 Александр Майко. All rights reserved.
//

import Foundation
import Alamofire


class AlamofireNetworkRequest {
    
    static var onProgress: ((Double) ->())?
    static var completed: ((String) ->())?
    
    
    
    //MARK: ОТПРАВЛЯЕМ ЗАПРОС ЧЕРЕЗ Alamofire !!!!!!!!!!
    
    static func sendRequest(url: String, completion : @escaping(_ courses1: [Course])->()) {
        guard let url = URL(string: url) else { return }
        AF.request(url, method: .get).validate().responseJSON { (response) in //встроеный метод request отправояет запрос, а responseJSON говорит о том, что ответ нам нужен в формате JSON, validate говорит о том, что свойство success будет срабатывать только при условии получения кода от 200 до 299
            
            switch response.result {
            
            case .success(let value):
                var courses = [Course]()
                courses = Course.getArray(from: value)!
                completion(courses)//вызываем клоужер, чтобы в него передать значение массива полученных данных, чтобы далее в классе coursesVC вызвать этот метод и переданный массив применить к тэйбл вью
            
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //MARK:    Получаем Data через Alamofire и сетаем как изображение  !!
    static func fetchDataWithAlamofire(url: String,  completion: @escaping (_ image: UIImage)->()){
        
        AF.request(url).responseData { (responseData) in
            switch responseData.result {
            
            case .success(let data):
                guard let image = UIImage(data: data) else { return }
                completion(image)
                
            case .failure(let error):
                print(error)
                
            }
        }
        
    }
    
    static func responseData(url: String) {
        
        //MARK:      Получаем Data через Alamofire и сетаем как стринг !!
        
        AF.request(url).responseData { (responseData) in
            switch responseData.result {
            
            case .success(let data):
                guard let string = String(data: data, encoding: .utf8) else { return }
                print(string)
                
            case .failure(let error):
                print(error)
                
            }
        }
    }
    
    //MARK:   Получение данных сразу в формате string без необходимости енкодинга !!!
    
    static func responseString(url: String) {
        AF.request(url).responseString { (responseString) in
            switch responseString.result {
            
            case .success(let string):
                print(string)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //MARK:     получение данных в оригинальном стандарте, подходит в тех случаях, когда необходимо сделать приведение к определенному типу вручную !!!!
    
    static func request(url: String) {
        
        AF.request(url).response { (response) in
            guard
                let data = response.data,
                let string = String(data: data, encoding: .utf8)
            else { return }
            print(string)
        }
        
    }
    
    
    //MARK:    загрузка данных с отоброжением прогресса загрузки !!!!!!!!!!
    
    static func downloadWithProgress(url: String, completion: @escaping (_ image: UIImage)->()) {
        AF.request(url).responseData { (responseData) in
            switch responseData.result {
            
            case .success(let data):
                guard let image = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    completion(image)
                }
                
                
            case .failure(let error):
                print(error)
                
            }
        }.downloadProgress { (progress) in
            print("Total unit count: \(progress.totalUnitCount)\n")
            print("Completed unit count: \(progress.completedUnitCount)\n")
            print("Fraction completed: \(progress.fractionCompleted)\n")
            print("Localized description: \(progress.localizedDescription!)\n")
            print("------------------------------------------------------------")
            
            self.onProgress?(progress.fractionCompleted)
            self.completed?(progress.localizedDescription)
            
            
        }
    }
    
    //MARK: отправка данных на сервер с помощью Alamofire !!!!
    
    static func postRequest(url: String, completion : @escaping(_ courses2: [Course])->()){
        
        guard let url = URL(string: url) else { return }
        
        let userData: [String: Any] = ["name" : "Network Request", "link": "https://swiftbook.ru/contents/our-first-applications/","imageUrl": "https://swiftbook.ru/wp-content/uploads/sites/2/2018/08/notifications-course-with-background.png", "numberOfLessons": 18, "numberOfTests": 10]
        
        AF.request(url, method: .post, parameters: userData).responseJSON { (responseJSON) in
            guard let statusCode = responseJSON.response?.statusCode else { return }
            print("Status Code:", statusCode)
            
            switch responseJSON.result {
            
            case .success(let value):
                print(value)
                guard let jsonObject = value as? [String: Any],
                      let course = Course(json: jsonObject)
                else { return }
                
                var courses = [Course]()
                courses.append(course)
                completion(courses)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    static func putRequest(url: String, completion : @escaping(_ courses2: [Course])->()){
        
        guard let url = URL(string: url) else { return }
        
        let userData: [String: Any] = ["name" : "Network Request (put)", "link": "https://swiftbook.ru/contents/our-first-applications/","imageUrl": "https://swiftbook.ru/wp-content/uploads/sites/2/2018/08/notifications-course-with-background.png", "numberOfLessons": 18, "numberOfTests": 10]
        
        AF.request(url, method: .put, parameters: userData).responseJSON { (responseJSON) in
            guard let statusCode = responseJSON.response?.statusCode else { return }
            print("Status Code:", statusCode)
            
            switch responseJSON.result {
            
            case .success(let value):
                print(value)
                guard let jsonObject = value as? [String: Any],
                      let course = Course(json: jsonObject)
                else { return }
                
                var courses = [Course]()
                courses.append(course)
                completion(courses)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
// progress.totalUnitCount - общий объем загружаемого файла
// progress.completedUnitCount - загруженный объем
// progress.fractionCompleted - результат деления completed на total
// progress.localizedDescription - описание хода загрузки
//  progress.localizedAdditionalDescription - детальное описание хода загрузки


