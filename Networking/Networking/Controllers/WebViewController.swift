//
//  WebViewController.swift
//  Networking
//
//  Created by Александр Майко on 29.09.2020.
//  Copyright © 2020 Александр Майко. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    var courseURL = ""

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let url = URL(string: courseURL) else { return }
        let request = URLRequest(url: url)
        
        webView.load(request)

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
