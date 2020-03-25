//
//  ViewControllerExtension.swift
//  classi
//
//  Created by Andrew Lawler on 23/03/2020.
//  Copyright © 2020 andrewlawler. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func presentClassiAlertOnMainThread(title: String, message: String, buttonTitle: String){
        DispatchQueue.main.async {
            let alertVC = ClassiAlertVC(title: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
    
}

