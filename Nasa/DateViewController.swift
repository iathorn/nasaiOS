//
//  DateViewController.swift
//  Nasa
//
//  Created by 최동호 on 2018. 2. 12..
//  Copyright © 2018년 최동호. All rights reserved.
//

import UIKit

class DateViewController: UIViewController {
    
    
    let datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.translatesAutoresizingMaskIntoConstraints = false
        dp.timeZone = NSTimeZone.local
        dp.maximumDate = Calendar.current.date(byAdding: .day, value: 0, to: Date())
        dp.backgroundColor = UIColor.black
        dp.setValue(UIColor.white, forKey: "textColor")
        return dp
    }()

    
    let dateSelectButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Let's See!", for: UIControlState.normal)
        btn.addTarget(self, action: #selector(selectDateAndSee), for: UIControlEvents.touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black
        guard let navController = self.navigationController else {
            return
        }
        navController.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navController.navigationBar.topItem?.title = "Date view"
        navController.navigationBar.barTintColor = UIColor.black
        
        
        
//        Date Picker..
        self.view.addSubview(self.datePicker)
        if #available(iOS 11.0, *) {
            self.datePicker.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
            self.datePicker.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
            self.datePicker.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: 10).isActive = true
            self.datePicker.heightAnchor.constraint(equalToConstant: 150).isActive = true

        } else {
            self.datePicker.topAnchor.constraint(equalTo: self.view.topAnchor, constant: navController.navigationBar.frame.size.height + UIApplication.shared.statusBarFrame.height + 20).isActive = true
            self.datePicker.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
            self.datePicker.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 10).isActive = true
            self.datePicker.heightAnchor.constraint(equalToConstant: 150).isActive = true
            
        }
        
//        select button..
        
        self.view.addSubview(self.dateSelectButton)
        
        self.dateSelectButton.topAnchor.constraint(equalTo: self.datePicker.bottomAnchor, constant: 20.0).isActive
         = true
        self.dateSelectButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30.0).isActive = true
        self.dateSelectButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30.0).isActive = true
        self.dateSelectButton.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        
    }
    
    @objc func selectDateAndSee() {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let selectedDate: String = dateFormatter.string(from: self.datePicker.date)
        print(selectedDate)
        
        let destVC = DetailDateViewController(nibName: nil, bundle: nil)
        destVC.receivedDate = selectedDate
        
        self.navigationController?.pushViewController(destVC, animated: true)
    }

}
