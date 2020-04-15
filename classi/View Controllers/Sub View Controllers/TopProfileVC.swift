//
//  TopProfileVC.swift
//  classi
//
//  Created by Andrew Lawler on 08/03/2020.
//  Copyright © 2020 andrewlawler. All rights reserved.
//

import UIKit

class TopProfileVC: UIViewController {
    
    let profileImage = UIImageView()
    let profileName = UILabel()
    let profileBio = UILabel()
    let listCarButton = ClassiButton(backgroundColor: .white, title: "List your car", textColor: .classiBlue, borderColour: .classiBlue)
    let buttonInfoLabel = UILabel()
    
    var userID: Auth?
    var myDelegate: InnerChild?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .classiBlue
        configureUI()
    }
    
    init(name: String, bio: String, id: Auth, img: String?) {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .classiBlue
        configureUI()
        profileName.text = name
        profileBio.text = bio
        userID = id
        profileImage.load(url: URL(string: img!)!)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getImg(_ img : String?) {
        guard let img = img else {
            profileImage.image = UIImage(named: "Default")
            return
        }
        profileImage.load(url: URL(string: "https://classi-server.herokuapp.com\(img)")!)
    }
    
    @objc func listCar() {
        let destVC = ListCarVC()
        destVC.myDelegate = self
        destVC.userID = userID
        let navController = UINavigationController(rootViewController: destVC)
        navController.navigationBar.isTranslucent = false
        navController.navigationBar.prefersLargeTitles = true
        let headerAppearance = editAppearance()
        navController.navigationBar.scrollEdgeAppearance = headerAppearance
        navController.navigationBar.standardAppearance = headerAppearance
        present(navController, animated: true)
    }
    
    func editAppearance() -> UINavigationBarAppearance {
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithOpaqueBackground()
        coloredAppearance.backgroundColor = .classiBlue
        coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        return coloredAppearance
    }

    func configureUI() {
        
        let profileImageView = UIView()
        profileImageView.addSubview(profileImage)
        profileImageView.layer.cornerRadius = 80
        profileImageView.layer.masksToBounds = true
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.layer.borderWidth = 5
        profileImageView.layer.borderColor = UIColor.white.cgColor
        
        profileImage.layer.cornerRadius = 80
        profileImage.clipsToBounds = true
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        
        // configure button info label
        
        buttonInfoLabel.text = "Click above to list your car on the marketplace."
        buttonInfoLabel.font = UIFont(name: "HelveticaNeue-italic", size: 15)
        buttonInfoLabel.textColor = .white
        buttonInfoLabel.textAlignment = .center
        buttonInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        buttonInfoLabel.adjustsFontSizeToFitWidth = true
        
        // configure profile name label
        
        profileName.translatesAutoresizingMaskIntoConstraints = false
        profileName.textAlignment = .center
        profileName.font = UIFont(name: "HelveticaNeue-Bold", size: 28)
        profileName.adjustsFontSizeToFitWidth = true
        profileName.textColor = .white
        profileName.numberOfLines = 1
        
        // configure profile bio label
        
        profileBio.translatesAutoresizingMaskIntoConstraints = false
        profileBio.textAlignment = .center
        profileBio.font = UIFont(name: "HelveticaNeue", size: 22)
        profileBio.textColor = .white
        profileBio.numberOfLines = 3
        profileBio.adjustsFontSizeToFitWidth = true
        
        view.addSubview(profileImageView)
        view.addSubview(profileName)
        view.addSubview(profileBio)
        view.addSubview(listCarButton)
        view.addSubview(buttonInfoLabel)
        
        listCarButton.addTarget(self, action: #selector(listCar), for: .touchUpInside)
        listCarButton.layer.cornerRadius = 26
        
        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            profileImageView.widthAnchor.constraint(equalToConstant: 160),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.heightAnchor.constraint(equalToConstant: 160),
            
            profileImage.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            profileImage.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor),
            profileImage.widthAnchor.constraint(equalToConstant: 160),
            profileImage.heightAnchor.constraint(equalToConstant: 160),
            
            profileName.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: padding),
            profileName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileName.widthAnchor.constraint(equalToConstant: view.frame.width-60),
            profileName.heightAnchor.constraint(equalToConstant: 30),
            
            profileBio.topAnchor.constraint(equalTo: profileName.bottomAnchor, constant: 10),
            profileBio.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileBio.widthAnchor.constraint(equalToConstant: view.frame.width-40),
            profileBio.heightAnchor.constraint(equalToConstant: 60),
            
            listCarButton.topAnchor.constraint(equalTo: profileBio.bottomAnchor, constant: 20),
            listCarButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            listCarButton.heightAnchor.constraint(equalToConstant: 50),
            listCarButton.widthAnchor.constraint(equalToConstant: 200),
            
            buttonInfoLabel.topAnchor.constraint(equalTo: listCarButton.bottomAnchor, constant: 10),
            buttonInfoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonInfoLabel.heightAnchor.constraint(equalToConstant: 22),
            buttonInfoLabel.widthAnchor.constraint(equalToConstant: view.frame.width-40),
            
        ])
        
        
    }

}

extension TopProfileVC: FromModal {
    
    func fromModal(answer: Bool) {
        if answer == true {
            myDelegate?.fromChild(answer: true)
        }
    }
    
}
