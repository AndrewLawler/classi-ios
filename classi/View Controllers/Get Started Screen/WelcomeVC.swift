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
    let loginLabel = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // setup the UI elements
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func setupUI() {
        view.backgroundColor = .white
        setupClassiLogo()
        setupButtons()
        setupLoginLabel()
        
        // apply all of our constraints
        let padding: CGFloat = 20
        let itemPadding: CGFloat = 40
        
        NSLayoutConstraint.activate([
            
            classiLogo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 220),
            classiLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            classiLogo.widthAnchor.constraint(equalToConstant: 350),
            classiLogo.heightAnchor.constraint(equalToConstant: 190),
            
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
    
    func setupButtons() {
        view.addSubview(getStartedButton)
        view.addSubview(loginButton)
        
        getStartedButton.addTarget(self, action: #selector(clickedSignup), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(clickedLogin), for: .touchUpInside)
    }
    
    func setupClassiLogo() {
        view.addSubview(classiLogo)
        classiLogo.image = UIImage(named: "logoImage")
        classiLogo.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupLoginLabel() {
        //view.addSubview(loginLabel)
        loginLabel.textAlignment = .center
        loginLabel.isUserInteractionEnabled = true
        loginLabel.adjustsFontSizeToFitWidth = true
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let attributedString = NSMutableAttributedString(string: "I already have an account! Log me in.", attributes: [
          .font: UIFont(name: "HelveticaNeue", size: 20),
          .foregroundColor: UIColor.systemGray2
        ])
        attributedString.addAttributes([
          .font: UIFont(name: "HelveticaNeue-Bold", size: 20),
          .foregroundColor: UIColor.classiBlue
        ], range: NSRange(location: 26, length: 10))
        loginLabel.attributedText = attributedString
        
        let loginTap = UITapGestureRecognizer(target: self, action: #selector(clickedLogin))
        loginLabel.addGestureRecognizer(loginTap)
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

