//
//  SignUpVC.swift
//  classi
//
//  Created by Andrew Lawler on 23/03/2020.
//  Copyright © 2020 andrewlawler. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController {
    
    let classiLogo = UIImageView()
    let nameField = ClassiTextField(placeholder: "Full Name", backgroundColour: .white, outline: .classiBlue)
    let emailField = ClassiTextField(placeholder: "E-Mail", backgroundColour: .white, outline: .classiBlue)
    let passwordField = ClassiTextField(placeholder: "Password", backgroundColour: .white, outline: .classiBlue)
    let loginButton = ClassiButton(backgroundColor: .classiBlue, title: "Sign Up", textColor: .white, borderColour: .white)
    let skipLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: true)
        configUI()
    }
    
    @objc func loginButtonTapped() {
        
        NetworkManager.shared.createUser(name: nameField.text!, email: emailField.text!.lowercased(), password: passwordField.text!) { [weak self] result in
            switch result {
            case.success(let response):
                DispatchQueue.main.async {
                    self!.goToApp(id: response)
                }
            case.failure(let error):
                print(error.rawValue)
            }
        }
        
    }
    
    @objc func clickedSkip() {
        goToApp(id: nil)
    }
    
    func configUI() {
        view.addSubview(classiLogo)
        view.addSubview(nameField)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(loginButton)
        view.addSubview(skipLabel)
        
        classiLogo.translatesAutoresizingMaskIntoConstraints = false
        classiLogo.image = UIImage(named: "logoImage")
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        passwordField.isSecureTextEntry = true
        
        skipLabel.textAlignment = .center
        skipLabel.isUserInteractionEnabled = true
        skipLabel.adjustsFontSizeToFitWidth = true
        skipLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let attributedString = NSMutableAttributedString(string: "Click here to skip the sign up and just enjoy the app!", attributes: [
            .font: UIFont(name: "HelveticaNeue", size: 25),
            .foregroundColor: UIColor.systemGray2
        ])
        attributedString.addAttributes([
            .font: UIFont(name: "HelveticaNeue-Bold", size: 25),
            .foregroundColor: UIColor.classiBlue
        ], range: NSRange(location: 6, length: 4))
        skipLabel.attributedText = attributedString
        let loginTap = UITapGestureRecognizer(target: self, action: #selector(clickedSkip))
        skipLabel.addGestureRecognizer(loginTap)
        
        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            
            classiLogo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 140),
            classiLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            classiLogo.widthAnchor.constraint(equalToConstant: 300),
            classiLogo.heightAnchor.constraint(equalToConstant: 160),
            
            nameField.topAnchor.constraint(equalTo: classiLogo.bottomAnchor, constant: padding),
            nameField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameField.heightAnchor.constraint(equalToConstant: 60),
            nameField.widthAnchor.constraint(equalToConstant: 300),
            
            emailField.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: padding),
            emailField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailField.heightAnchor.constraint(equalToConstant: 60),
            emailField.widthAnchor.constraint(equalToConstant: 300),
            
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: padding),
            passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordField.heightAnchor.constraint(equalToConstant: 60),
            passwordField.widthAnchor.constraint(equalToConstant: 300),
            
            loginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: padding*2),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 60),
            loginButton.widthAnchor.constraint(equalToConstant: 200),
            
            skipLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding*3),
            skipLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            skipLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            skipLabel.heightAnchor.constraint(equalToConstant: 50),
        
        ])
    }
    
    func goToApp(id: Auth?) {
        let searchVC = SearchVC()
        searchVC.title = "Search"
        searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        searchVC.userID = id
        
        let favouritesVC = FavouritesVC()
        favouritesVC.title = "Favourites"
        favouritesVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        favouritesVC.userID = id
        
        let navController = UINavigationController(rootViewController: searchVC)
        navController.navigationBar.prefersLargeTitles = true
        navController.navigationBar.backgroundColor = .classiBlue
        navController.navigationBar.tintColor = .white
        navController.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navController.navigationBar.barStyle = .black
        
        let navControllerTwo = UINavigationController(rootViewController: favouritesVC)
        navControllerTwo.navigationBar.prefersLargeTitles = true
        navControllerTwo.navigationBar.backgroundColor = .classiBlue
        navControllerTwo.navigationBar.tintColor = .white
        navControllerTwo.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navControllerTwo.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navControllerTwo.navigationBar.barStyle = .black
        
        let tabbar = UITabBarController()
        tabbar.tabBar.barTintColor = .classiBlue
        tabbar.tabBar.tintColor = .white
        tabbar.tabBar.unselectedItemTintColor = .systemTeal
        tabbar.viewControllers = [navController, navControllerTwo]
        tabbar.tabBar.isTranslucent = false
        
        navigationController?.pushViewController(tabbar, animated: true)
    }
    
}
