//
//  WelcomeVC.swift
//  classi
//
//  Created by Andrew Lawler on 08/03/2020.
//  Copyright © 2020 andrewlawler. All rights reserved.
//

import UIKit

class WelcomeVC: UIViewController {
    
    let classiLogo = UIImageView()
    let getStartedButton = ClassiButton(backgroundColor: .classiBlue, title: "Let's get started!", textColor: .white, borderColour: .white)
    let loginButton = ClassiButton(backgroundColor: .white, title: "Login", textColor: .classiBlue, borderColour: .classiBlue)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
    }
    
    func setupView() {
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func setupUI() {
        view.addSubview(classiLogo)
        view.addSubview(getStartedButton)
        view.addSubview(loginButton)
        
        classiLogo.image = UIImage(named: "logoImage")
        classiLogo.contentMode = .scaleAspectFill
        classiLogo.translatesAutoresizingMaskIntoConstraints = false
        
        getStartedButton.addTarget(self, action: #selector(clickedSignup), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(clickedLogin), for: .touchUpInside)
        
        let padding: CGFloat = 20
        let itemPadding: CGFloat = 40
        
        let topAnchorConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 100 : 190
        
        NSLayoutConstraint.activate([
            classiLogo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topAnchorConstant),
            classiLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            classiLogo.widthAnchor.constraint(equalToConstant: 300),
            classiLogo.heightAnchor.constraint(equalToConstant: 140),
            
            getStartedButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            getStartedButton.heightAnchor.constraint(equalToConstant: 60),
            getStartedButton.widthAnchor.constraint(equalToConstant: 250),
            getStartedButton.topAnchor.constraint(equalTo: classiLogo.bottomAnchor, constant: itemPadding*3),
            
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: getStartedButton.bottomAnchor, constant: padding),
            loginButton.heightAnchor.constraint(equalToConstant: 60),
            loginButton.widthAnchor.constraint(equalToConstant: 250),
        ])
    }
    
    @objc func clickedLogin() {
        let destVC = LoginVC()
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    @objc func clickedSignup() {
        let destVC = SignUpVC()
        navigationController?.pushViewController(destVC, animated: true)
    }
        
}

