//
//  CoursesViewController.swift
//  Networking
//
//  Created by Александр Майко on 29.09.2020.
//  Copyright © 2020 Александр Майко. All rights reserved.
//

import Foundation
import UIKit

class CoursesViewController : UIViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let webViewController = segue.destination as! WebViewController
        guard courseUrl != nil else { return }
        if let url = courseUrl {
        webViewController.courseURL = url
        }
//        webViewController.courseURL = courseURL!
    }
    
    private var courses = [Course]()
    private var courseName: String?
    private var courseUrl: String?
    private let url = "https://swiftbook.ru//wp-content/uploads/api/api_courses"
    private var postRequestUrl = "https://jsonplaceholder.typicode.com/posts"
    private var putRequestUrl = "https://jsonplaceholder.typicode.com/posts/1"
    @IBOutlet weak var coursesTableView: UITableView!
    
    
    
    //MARK: //ПОЛУЧАЕМ ДАННЫЕ С ПОМОЩЬЮ СТАНДАРТНОГО URLSession  !!!!
    
    
    func fetchData() {
        NetworkManager.fetchData(url: url) { (yyyyy) in  //ЗАМЫКАНИЕ
            self.courses = yyyyy
            DispatchQueue.main.async {
                self.coursesTableView.reloadData()
            }
        }
        
    }
  
    
 //MARK:   // ПОЛУЧАЕМ ДАННЫЕ С ПОМОЩЬЮ Alamofire !!!!!!
    
    func fetchDataWithAlamofire() {
        AlamofireNetworkRequest.sendRequest(url: url) { (courses) in
            self.courses = courses
            
            DispatchQueue.main.async {
                self.coursesTableView.reloadData()
            }
        }
    }
    
    func postWithAlamofire(){
        AlamofireNetworkRequest.postRequest(url: postRequestUrl) { (course) in
            self.courses = course
            
            DispatchQueue.main.async {
                self.coursesTableView.reloadData()
            }
        }
    }
    
    func putWithAlamofire(){
        AlamofireNetworkRequest.putRequest(url: putRequestUrl) { (course) in
            self.courses = course
            
            DispatchQueue.main.async {
                self.coursesTableView.reloadData()
            }
        }
    }
    
    
    
    private func configureCell(cell: TableViewCell, for indexPath: IndexPath) {
        let course = courses[indexPath.row]
        cell.NameOfCoursesLabel.text = course.name
        
        if course.numberOfLessons != nil {
            cell.NumberOfLessonsLabel.text = "number of lessons: \(course.numberOfLessons!)"
    }
        if course.numberOfTests != nil {
            cell.NumberOfTestsLabel.text = "number of tests: \(course.numberOfTests!)"
        }
        DispatchQueue.global().async {
            guard let imageURL = URL(string: course.imageUrl!) else { return }
            guard let imageData = try? Data(contentsOf: imageURL) else { return }
            DispatchQueue.main.async {
            cell.ImageView.image = UIImage(data: imageData)

            }
        }

    }
    
}



extension CoursesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        courses.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TableViewCell
        configureCell(cell: cell, for: indexPath)
        return cell
    }


}

extension CoursesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let course = courses[indexPath.row]
        courseName = course.name
        courseUrl = course.link
        
        performSegue(withIdentifier: "goToWebView", sender: self)
    }
}
