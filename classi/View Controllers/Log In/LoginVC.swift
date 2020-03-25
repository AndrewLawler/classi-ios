//
//  LoginVC.swift
//  classi
//
//  Created by Andrew Lawler on 23/03/2020.
//  Copyright © 2020 andrewlawler. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    let classiLogo = UIImageView()
    let emailField = ClassiTextField(placeholder: "E-Mail", backgroundColour: .white, outline: .classiBlue)
    let passwordField = ClassiTextField(placeholder: "Password", backgroundColour: .white, outline: .classiBlue)
    let loginButton = ClassiButton(backgroundColor: .classiBlue, title: "Login", textColor: .white, borderColour: .white)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: true)
        configUI()
    }
    
    @objc func loginButtonTapped() {
        emailField.text = "andy@classi.com"
        passwordField.text = "123"
        NetworkManager.shared.authoriseUser(email: emailField.text!.lowercased(), password: passwordField.text!) { [weak self] result in
            switch result {
            case.success(let response):
                DispatchQueue.main.async {
                    let searchVC = SearchVC()
                    searchVC.title = "Search"
                    searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
                    searchVC.userID = response
                    
                    let favouritesVC = FavouritesVC()
                    favouritesVC.title = "Favourites"
                    favouritesVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
                    favouritesVC.userID = response
                    
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
                    
                    self?.navigationController?.pushViewController(tabbar, animated: true)
                }
            case.failure(let error):
                print(error.rawValue)
            }
        }
        
    }
    
    func configUI() {
        view.addSubview(classiLogo)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(loginButton)
        
        classiLogo.translatesAutoresizingMaskIntoConstraints = false
        classiLogo.image = UIImage(named: "logoImage")
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        passwordField.isSecureTextEntry = true
        
        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            
            classiLogo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 200),
            classiLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            classiLogo.widthAnchor.constraint(equalToConstant: 300),
            classiLogo.heightAnchor.constraint(equalToConstant: 160),
            
            emailField.topAnchor.constraint(equalTo: classiLogo.bottomAnchor, constant: padding),
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
        
        ])
    }
    

}
