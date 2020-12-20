//
//  MainViewController.swift
//  Networking
//
//  Created by Александр Майко on 25.10.2020.
//  Copyright © 2020 Александр Майко. All rights reserved.
//

import UIKit
import UserNotifications

private let reuseIdentifier = "Cell"
private let url = "https://jsonplaceholder.typicode.com/posts"
private let uploadImageUrl = "https://api.imgur.com/3/image"
private let urlApi = "https://swiftbook.ru//wp-content/uploads/api/api_courses"

enum Actions: String, CaseIterable { //CaseIterable позволяет вернуть с помощью allCases содержимае перечисления в виде массива
    case downloadImage = "Download Image"
    case get = "GET"
    case post = "POST"
    case ourCourses = "Our Courses"
    case uploadImage = "Upload Image"
    case downloadFile = "Download File"
    case ourCoursesAlamofire = "Our Courses (Alamofire)"
    case responseData = "Response data (Alamofire)"
    case responseString = "Response String (Alamofire)"
    case response = "Response (Alamofire)"
    case downloadLargeImage = "Download large image (Alamofire) with progress "
    case postWithAlamofire = "Post with Alamofire"
    case putWithAlamofire = "Put with Alamofire"
    //case uploadImageAlamofire = "Upload image (Alamofire)"
}


class MainViewController: UICollectionViewController {
    
    let actions = Actions.allCases
    private var alertController: UIAlertController!
    private let dataProvider = DataProvider()
    private var filePath: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerForNatification()
        
        dataProvider.fileLocation = { (location) in
            //Сохранить файл для дальнейшего использования
            print("Download finished: \(location.absoluteString)")
            self.filePath = location.absoluteString
            self.alertController.dismiss(animated: false, completion: nil)
            self.postNatification()
            
        }
    }
    
    private func showAlert() { //Алёрт контроллер!!!!!!!!!!!
    
        
        alertController = UIAlertController(title: "Downloading...", message: "0%", preferredStyle: .alert)
        
        var hight = NSLayoutConstraint(item: alertController.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 170)
        alertController.view.addConstraint(hight)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            self.dataProvider.stopDownload()
        }
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true) {
            
            let size = CGSize(width: 40, height: 40)
            let point = CGPoint(x: self.alertController.view.frame.width / 2 - size.width / 2, y: self.alertController.view.frame.height / 2 - size.height / 2)
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(origin: point, size: size))
            activityIndicator.color = .gray
            activityIndicator.startAnimating()
            
            let progressView = UIProgressView(frame: CGRect(x: 0, y: self.alertController.view.frame.height - 44, width: self.alertController.view.frame.width, height: 2))
            progressView.tintColor = .blue
            
            self.dataProvider.onProgress = { (progress) in
                progressView.progress = Float(progress)
                self.alertController.message = String(Int(progress * 100)) + "%"
                
            }
            
            self.alertController.view.addSubview(activityIndicator)
            self.alertController.view.addSubview(progressView)
            
        }
    }

    // MARK: UICollectionViewDataSource


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return actions.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
        cell.label.text = actions[indexPath.row].rawValue
        return cell
    }

    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let action = actions[indexPath.row]
        
        switch action {
        case .downloadImage :
            performSegue(withIdentifier: "downloadImage", sender: self)
        case .get :
            NetworkManager.getRequest(url: url)
        case .post :
            NetworkManager.postRequest(url: url)
        case .ourCourses :
            performSegue(withIdentifier: "getCourses", sender: self)
        case .uploadImage :
            NetworkManager.uploadImage(url: uploadImageUrl)
        case .downloadFile:
            showAlert()
            dataProvider.startDownload()
        case .ourCoursesAlamofire:
            performSegue(withIdentifier: "getCoursesWithAlamofire", sender: self)
        case .responseData:
            performSegue(withIdentifier: "responseData", sender: self)
            //AlamofireNetworkRequest.responseData(url: urlApi)
        case .responseString:
            AlamofireNetworkRequest.responseString(url: urlApi)
        case .response:
            AlamofireNetworkRequest.request(url: urlApi)
        case .downloadLargeImage:
            performSegue(withIdentifier: "downloadLargeImage", sender: self)
        case .postWithAlamofire:
            performSegue(withIdentifier: "postWithAlamofire", sender: self)
        case .putWithAlamofire:
            performSegue(withIdentifier: "putWithAlamofire", sender: self)
      //  case .uploadImageAlamofire:
            //AlamofireNetworkRequest.uploadImageAF(url: uploadImageUrl)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let coursesVC = segue.destination as? CoursesViewController
        let imageVC = segue.destination as? ImageViewController
        
        switch segue.identifier {
        
        case "getCourses":
            coursesVC?.fetchData()
            
        case "getCoursesWithAlamofire":
            coursesVC?.fetchDataWithAlamofire()
            
        case "downloadImage":
            imageVC?.fetchData()
            
        case "responseData":
            imageVC?.fetchDataWithAlamofire1()
            
        case "downloadLargeImage":
            imageVC?.downloadImageWithProgress()
            
        case "postWithAlamofire":
            coursesVC?.postWithAlamofire()
        case "putWithAlamofire":
            coursesVC?.putWithAlamofire()
            
        default:
            break
        }
    }
}

extension MainViewController {
    private func registerForNatification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (_, _) in
            
        }
    }
    
    private func postNatification() {
        let content = UNMutableNotificationContent()
        content.title = "Download complete!"
        content.body = "Your background body has completed \(self.filePath)"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let request = UNNotificationRequest(identifier: "Transfer Complete", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
