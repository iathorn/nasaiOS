//
//  ViewController.swift
//  Nasa
//
//  Created by 최동호 on 2018. 2. 12..
//  Copyright © 2018년 최동호. All rights reserved.
//

import UIKit

struct Nasa: Decodable {
    let copyright: String
    let date: String
    let explanation: String
    let hdurl: String
    let media_type: String
    let service_version: String
    let title: String
    let url: String
    
        init(json: [String: Any]) {
            copyright = (json["copyright"] as? String?)! ?? ""
            date = (json["date"] as? String?)! ?? ""
            explanation = (json["explanation"] as? String?)! ?? ""
            hdurl = (json["hdurl"] as? String?)! ?? ""
            media_type = (json["media_type"] as? String?)! ?? ""
            service_version = (json["service_version"] as? String?)! ?? ""
            title = (json["title"] as? String?)! ?? ""
            url = (json["url"] as? String?)! ?? ""
        }
}

class ViewController: UIViewController {
    
    var apiDate: Date = Date()
    
    
    let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .gray
        return imageView
    }()
    
    

    let prevButton: UIButton = {
       let button = UIButton(type: UIButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Prev Date", for: UIControlState.normal)
//        button.backgroundColor = .blue
        return button
    }()
    
    let nextButton: UIButton = {
       let button = UIButton(type: UIButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Next Date", for: UIControlState.normal)
//        button.backgroundColor = .red
        return button
    }()
    
    let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = UILayoutConstraintAxis.horizontal
        stackView.distribution = UIStackViewDistribution.fillEqually
//        stackView.alignment = UIStackViewAlignment.center
//        stackView.spacing = 10
        
        return stackView
    }()
    
    let webView: UIWebView = {
        let webView = UIWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.backgroundColor = .gray
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        guard let navController = self.navigationController else {
            return
        }
        navController.navigationBar.topItem?.title = "Today view"
        
//
        self.view.addSubview(self.mainImageView)
        self.view.addSubview(self.webView)
        
        
        
        self.prevButton.addTarget(self, action: #selector(getPrevData), for: UIControlEvents.touchUpInside)
        self.nextButton.addTarget(self, action: #selector(getNextData), for: UIControlEvents.touchUpInside)
        
        self.view.addSubview(self.buttonStackView)
        self.buttonStackView.addArrangedSubview(self.prevButton)
        self.buttonStackView.addArrangedSubview(self.nextButton)

        self.buttonStackView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor, constant: 0).isActive = true
        self.buttonStackView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.buttonStackView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.buttonStackView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        self.mainImageView.topAnchor.constraint(equalTo: self.buttonStackView.bottomAnchor, constant: 0).isActive = true
        self.mainImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.mainImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.mainImageView.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor, constant: 0).isActive = true
        
        self.webView.topAnchor.constraint(equalTo: self.buttonStackView.bottomAnchor, constant: 0).isActive = true
        self.webView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.webView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.webView.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor, constant: 0).isActive = true
        
        
       


        requestGetNasa()
//        requestGetNasa(date: "2018-01-28")
    }
    
    
    func requestGetNasa(date: String = "") {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let nasaURL: String = "https://api.nasa.gov/planetary/apod?api_key=3bPNuswHLRHGCeGrh7x0Jhn8Fb6me7NvEqvqjzu8&date=\(date)"
        
        guard let url = URL(string: nasaURL) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                return
            }
            //            let dataAsString = String(data: data, encoding: String.Encoding.utf8)
            //            print(dataAsString)
            
            do {
                
//                way of decode
//                let nasaResult = try JSONDecoder().decode(Nasa.self, from: data)
                
                
//                print(nasaResult.title)
//
//            way of jsonObject
            guard let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any] else {
                return
            }
            let nasaResult = Nasa(json: json)
            print(nasaResult.media_type)
            print(nasaResult.date)
                
//                if dateFormatter.date(from: nasaResult.date) == nil {
//
//                    return
//                } else {
//
//                }
                
                self.apiDate = dateFormatter.date(from: nasaResult.date)!
                
                
                
                if nasaResult.media_type == "image" {
                    DispatchQueue.main.async(execute: {
                        self.webView.isHidden = true
                        self.webView.loadRequest(URLRequest(url: URL(string: "about:blank")!))
                        self.webView.reload()
                        self.mainImageView.isHidden = false
                        self.mainImageView.setImageFromUrl(link: nasaResult.url)
                    })
                } else {
                    DispatchQueue.main.async(execute: {
                        self.mainImageView.isHidden = true
                        self.webView.isHidden = false
                        self.webView.loadRequest(URLRequest(url: URL(string: nasaResult.url)!))
                        
                    })
                }
                
                
                
            } catch let jsonErr {
                print("Error serializing json: ", jsonErr)
            }
            
            
            }.resume()
    }
    
    @objc func getPrevData() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        self.apiDate = Date(timeInterval:  -(60 * 60 * 24), since: self.apiDate)
        requestGetNasa(date: dateFormatter.string(from: self.apiDate))
        
    }
    
    @objc func getNextData() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if Date(timeInterval: 60 * 60 * 24, since: self.apiDate) > Date() {
            self.apiDate = Date()
        } else {
            self.apiDate = Date(timeInterval: 60 * 60 * 24, since: self.apiDate)
        }

        requestGetNasa(date: dateFormatter.string(from: self.apiDate))
    }
    

}

extension UIImageView {
    func setImageFromUrl(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let httpUrlResponse = response as? HTTPURLResponse, httpUrlResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                    let data = data, error == nil,
                let image = UIImage(data: data) else {
                    return
            }
            DispatchQueue.main.async() {
                self.image = image
            }
        }.resume()
    }
    
    func setImageFromUrl(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else {return}
        setImageFromUrl(url: url, contentMode: mode)
    }
}



