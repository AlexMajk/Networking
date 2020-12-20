//
//  ViewController.swift
//  Networking
//
//  Created by Александр Майко on 14.09.2020.
//  Copyright © 2020 Александр Майко. All rights reserved.
//

import UIKit
import Alamofire

class ImageViewController: UIViewController {
    
    private let url = "https://img-cdn.tinkoffjournal.ru/faq-turkey_main.ttorjyuxablm.jpg"
    private let urlLarge = "https://i.imgur.com/3416rvI.jpg"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var CompletedLabel: UILabel!
    
    
    func fetchData() {
        NetworkManager.downloadImage(url: url) { (image4) in
            //self.activityIndicator.stopAnimating()
            self.imageView.image = image4
            
        }
    }

    func fetchDataWithAlamofire1(){
        AlamofireNetworkRequest.fetchDataWithAlamofire(url: url) { (image) in
            self.imageView.image = image
            self.activityIndicator.stopAnimating()
        }
    }
    
    func downloadImageWithProgress(){
        
        AlamofireNetworkRequest.onProgress = { progress in
            self.progressView.isHidden = false
            self.progressView.progress = Float(progress)
        }
        
        AlamofireNetworkRequest.completed = { completed in
            self.CompletedLabel.isHidden = false
            self.CompletedLabel.text = completed
        }
        
        AlamofireNetworkRequest.downloadWithProgress(url: urlLarge) { (image) in
            self.imageView.image = image
            self.progressView.isHidden = true
            self.CompletedLabel.isHidden = true
            self.activityIndicator.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        // Do any additional setup after loading the view.
    }
    
}

