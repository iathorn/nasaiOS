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
    
    let group = DispatchGroup()
    let getSource = DispatchQueue(label: "getSource")
    let hidePrevSources = DispatchQueue(label: "hidePrevSources")
    let indicatorQueue = DispatchQueue(label: "indicatorQueue")
    let hideIndicatorQueue = DispatchQueue(label: "hideIndicatorQueue")
    
    let queue1 = DispatchQueue(label: "queue1")
    let queue2 = DispatchQueue(label: "queue2")
    let queue3 = DispatchQueue(label: "queue3")
    
    var flag: Bool = true
    
    
    var apiDate: Date = Date()
    
    var serverTime: String = ""
    
    let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        //        imageView.backgroundColor = .gray
        
        return imageView
    }()
    
    
    
    let prevButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Prev Date", for: UIControlState.normal)
        button.setTitleColor(UIColor.white, for: UIControlState.normal)
        //        button.backgroundColor = .blue
        return button
    }()
    
    let nextButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Next Date", for: UIControlState.normal)
        button.setTitleColor(UIColor.white, for: UIControlState.normal)
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
        webView.backgroundColor = .black
        
        return webView
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        //        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        return activityIndicator
    }()
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black
        guard let navController = self.navigationController else {
            return
        }
        navController.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navController.navigationBar.topItem?.title = "Today view"
        navController.navigationBar.barTintColor = UIColor.black
        //
        
        self.view.addSubview(self.mainImageView)
        self.webView.isHidden = true
        self.view.addSubview(self.webView)
        
        self.activityIndicator.center = self.view.center
        self.activityIndicator.hidesWhenStopped = true
        
        self.view.addSubview(self.activityIndicator)
        
        
        
        
        
        self.prevButton.addTarget(self, action: #selector(getPrevData), for: UIControlEvents.touchUpInside)
        self.nextButton.addTarget(self, action: #selector(getNextData), for: UIControlEvents.touchUpInside)
        
        self.view.addSubview(self.buttonStackView)
        
        
        self.buttonStackView.addArrangedSubview(self.prevButton)
        self.buttonStackView.addArrangedSubview(self.nextButton)
        
        if #available(iOS 11.0, *) {
            self.buttonStackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
            self.buttonStackView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
            self.buttonStackView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true
            self.buttonStackView.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            
            
            
        } else {
            self.buttonStackView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: navController.navigationBar.frame.size.height + UIApplication.shared.statusBarFrame.height).isActive = true
            self.buttonStackView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
            self.buttonStackView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
            self.buttonStackView.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
        }
        
        //
        //        self.buttonStackView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor, constant: 0).isActive = true
        //        self.buttonStackView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        //        self.buttonStackView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        //        self.buttonStackView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        self.mainImageView.topAnchor.constraint(equalTo: self.buttonStackView.bottomAnchor, constant: 0).isActive = true
        self.mainImageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.mainImageView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.mainImageView.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor, constant: 0).isActive = true
        
        
        
        
        self.webView.topAnchor.constraint(equalTo: self.buttonStackView.bottomAnchor, constant: 0).isActive = true
        self.webView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        self.webView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        self.webView.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor, constant: 0).isActive = true
        
        
        
        requestGetNasa()
        
    }
    
    
    
    
    
    func requestGetNasa(date: String = "") {
        
        DispatchQueue.global().async {
            
            
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
                    
                    //                guard self.apiDate = dateFormatter.date(from: nasaResult.date) else {
                    //                    return
                    //                }
                    
                    if self.flag == true {
                        self.serverTime = nasaResult.date
                        self.flag = false
                    }
                    
                    print(nasaResult.date)
                    
                    
                
                    
                    
                    self.apiDate = dateFormatter.date(from: nasaResult.date)!
                    
                    //                DispatchQueue.main.async {
                    //
                    //                    self.activityIndicator.startAnimating()
                    //                }
                    //
                    if nasaResult.media_type == "image" {
                        //
                        
                        
                        DispatchQueue.main.async {
                            //                            self.mainImageView.isHidden = true
                            self.activityIndicator.startAnimating()
                            //                            UIApplication.shared.beginIgnoringInteractionEvents()
                            
                            
                            DispatchQueue.main.async{
                                self.webView.isHidden = true
                                self.webView.loadRequest(URLRequest(url: URL(string: "about:blank")!))
                                self.webView.reload()
                                self.mainImageView.isHidden = false
                                self.mainImageView.image = nil
                                //                                Thread.sleep(forTimeInterval: 1.0)
                                
                                
                                DispatchQueue.main.async{
                                    self.mainImageView.setImageFromUrl(link: nasaResult.url)
                                    
                                    
                                    //                                    Thread.sleep(forTimeInterval: 3.0)
                                    
                                    DispatchQueue.main.async {
                                        self.activityIndicator.stopAnimating()
                                    }
                                    
                                }
                                
                            }
                            
                            
                            
                            
                        }
                        
                        
                    } else {
                        
                        self.hidePrevSources.async {
                            DispatchQueue.main.async(execute: {
                                self.mainImageView.isHidden = true
                                
                                
                            })
                        }
                        
                        self.getSource.async {
                            DispatchQueue.main.async(execute: {
                                self.webView.isHidden = false
                                self.webView.loadRequest(URLRequest(url: URL(string: nasaResult.url)!))
                            })
                        }

                    }
                    
                    
                    
                    
                    
                    
                } catch let jsonErr {
                    print("Error serializing json: ", jsonErr)
                }
                
                
                }.resume()
            
        }
        
        
        
    }
    
    @objc func getPrevData() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        self.apiDate = Date(timeInterval:  -(60 * 60 * 24), since: self.apiDate)
        requestGetNasa(date: dateFormatter.string(from: self.apiDate))
        
    }
    
    @objc func getNextData() {
        //        print(self.serverTime)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        //

        
        guard self.serverTime != "", Date(timeInterval: 60 * 60 * 24, since: self.apiDate) <= dateFormatter.date(from: self.serverTime)! else {
            let alert = UIAlertController(title: "오류", message: "날짜에 맞는 데이터가 없습니다.", preferredStyle: UIAlertControllerStyle.alert)
            
            
            alert.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            return
        }
        //        if Date(timeInterval: 60 * 60 * 24, since: self.apiDate) > Date() {
        //            self.apiDate = Date()
        //        } else {
        self.apiDate = Date(timeInterval: 60 * 60 * 24, since: self.apiDate)
        //        }
        
        //        print("실행")
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




