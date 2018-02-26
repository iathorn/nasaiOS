//
//  DetailDateViewController.swift
//  Nasa
//
//  Created by 최동호 on 2018. 2. 26..
//  Copyright © 2018년 최동호. All rights reserved.
//

import UIKit



class DetailDateViewController: UIViewController {
    
    
    var receivedDate: String?
    
    var flag: Bool = true
    
    var serverTime: String = ""
    
    let getSource = DispatchQueue(label: "getSource")
    let hidePrevSources = DispatchQueue(label: "hidePrevSources")
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .black
        return iv
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        
        return activityIndicator
    }()
    
    
    let webView: UIWebView = {
        let webView = UIWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.backgroundColor = .black
        
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        
        guard let navController = self.navigationController else {
            return
        }
//        webView
        
        self.webView.isHidden = true
        self.view.addSubview(self.webView)
        
        if #available(iOS 11.0, *) {
            self.webView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
            self.webView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
            self.webView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true
            self.webView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0.0).isActive = true
            
            
            
            
        } else {
            self.webView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: navController.navigationBar.frame.size.height + UIApplication.shared.statusBarFrame.height).isActive = true
            self.webView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
            self.webView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
            self.webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0.0).isActive = true
            
        }
        
//        imageView...
        
        
        
        self.view.addSubview(self.imageView)
        if #available(iOS 11.0, *) {
            self.imageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
            self.imageView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
            self.imageView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true
            self.imageView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0.0).isActive = true
            
            
            
            
        } else {
            self.imageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: navController.navigationBar.frame.size.height + UIApplication.shared.statusBarFrame.height).isActive = true
            self.imageView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
            self.imageView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
            self.imageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0.0).isActive = true
            
        }
        
        
        print("selected date: \(self.receivedDate!)")
        
        
        
        
        
        requestGetNasa(date: self.receivedDate!)
        
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
                    
                
                
                    
                    if self.flag == true {
                        self.serverTime = nasaResult.date
                        self.flag = false
                    }
                    
                    print(nasaResult.date)
                    
                    
                    guard nasaResult.url != "" else {
                        let alert = UIAlertController(title: "오류", message: "날짜에 맞는 데이터가 없습니다.", preferredStyle: UIAlertControllerStyle.alert)

                        alert.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: { (action) in
                            self.navigationController?.popToRootViewController(animated: true)
                        }))
                        
                        self.present(alert, animated: true, completion: nil)
                        
                        return
                    }
                    
               
//                    self.apiDate = dateFormatter.date(from: nasaResult.date)!
  
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
                                self.imageView.isHidden = false
                                self.imageView.image = nil
                                //                                Thread.sleep(forTimeInterval: 1.0)
                                
                                
                                DispatchQueue.main.async{
                                    self.imageView.setImageFromUrl(link: nasaResult.url)
                                    
                                    
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
                                self.imageView.isHidden = true
                                
                                
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
}
