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
    
    var users: [User] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: true)
        getUsers()
        configUI()
    }
    
    func getUsers() {
        NetworkManager.shared.getAllUsers { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let users):
                DispatchQueue.main.async {
                    self.users = users
                }
            case .failure(let error):
                print(error.rawValue)
            }
        }
    }
    
    func isAlreadyUser() -> Bool {
        var isUser = false
        let mail = emailField.text!.lowercased()
        for user in users {
            if mail == user.email {
                isUser = true
            }
        }
        return isUser
    }
    
    @objc func loginButtonTapped() {
        if isAlreadyUser() == false {
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
        } else {
            self.presentClassiAlertOnMainThread(title: "Already Registered", message: "That e-mail is already listed, please try again.", buttonTitle: "Ok")
            emailField.text = ""
        }
    }
    
    @objc func clickedSkip() {
        goToApp(id: nil)
    }
    
    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    func configUI() {
        createDismissKeyboardTapGesture()
        view.addSubview(classiLogo)
        view.addSubview(nameField)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(loginButton)
        view.addSubview(skipLabel)
        
        classiLogo.translatesAutoresizingMaskIntoConstraints = false
        classiLogo.image = UIImage(named: "logoImage")
        classiLogo.contentMode = .scaleAspectFill
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        passwordField.isSecureTextEntry = true
        
        skipLabel.textAlignment = .center
        skipLabel.isUserInteractionEnabled = true
        skipLabel.adjustsFontSizeToFitWidth = true
        skipLabel.translatesAutoresizingMaskIntoConstraints = false
        let loginTap = UITapGestureRecognizer(target: self, action: #selector(clickedSkip))
        skipLabel.addGestureRecognizer(loginTap)
        configureAttributedLabel(someLabel: skipLabel)
        
        let padding: CGFloat = 20
        
        let topAnchorConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 40 : 140
        
        NSLayoutConstraint.activate([
            
            classiLogo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topAnchorConstant),
            classiLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            classiLogo.widthAnchor.constraint(equalToConstant: 300),
            classiLogo.heightAnchor.constraint(equalToConstant: 140),
            
            nameField.topAnchor.constraint(equalTo: classiLogo.bottomAnchor, constant: padding+10),
            nameField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameField.heightAnchor.constraint(equalToConstant: 45),
            nameField.widthAnchor.constraint(equalToConstant: 300),
            
            emailField.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: padding),
            emailField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailField.heightAnchor.constraint(equalToConstant: 45),
            emailField.widthAnchor.constraint(equalToConstant: 300),
            
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: padding),
            passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordField.heightAnchor.constraint(equalToConstant: 45),
            passwordField.widthAnchor.constraint(equalToConstant: 300),
            
            loginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: padding*2),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 60),
            loginButton.widthAnchor.constraint(equalToConstant: 200),
            
            skipLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: padding),
            skipLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            skipLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            skipLabel.heightAnchor.constraint(equalToConstant: 30),
        
        ])
    }
    
    func configureAttributedLabel(someLabel: UILabel) -> UILabel {
        let attributedString = NSMutableAttributedString(string: "Click here to skip the sign up and just enjoy the app!", attributes: [
            .font: UIFont(name: "HelveticaNeue", size: 25),
            .foregroundColor: UIColor.systemGray2
        ])
        attributedString.addAttributes([
            .font: UIFont(name: "HelveticaNeue-Bold", size: 25),
            .foregroundColor: UIColor.classiBlue
        ], range: NSRange(location: 6, length: 4))
        someLabel.attributedText = attributedString
        return someLabel
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
