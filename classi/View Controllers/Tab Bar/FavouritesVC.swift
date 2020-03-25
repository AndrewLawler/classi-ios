//
//  FavouritesVC.swift
//  classi
//
//  Created by Andrew Lawler on 08/03/2020.
//  Copyright © 2020 andrewlawler. All rights reserved.
//

import UIKit

class FavouritesVC: UIViewController {
    
    var userID: Auth?
    let infoLabel = UILabel()
    let tableView = UITableView()
    
    var favouritedCars: [Listing] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        getUserFavourites()
        customiseNavigationBar()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let profileButton = UIImageView()
        let signoutButton = UIImageView()
        let signupButton = UIImageView()
        
        profileButton.image = UIImage(systemName: "person.circle")
        profileButton.tintColor = .classiBlue
        signoutButton.image = UIImage(systemName: "xmark.circle")
        signoutButton.tintColor = .classiBlue
        signupButton.image = UIImage(systemName: "person.crop.circle.badge.plus")
        signupButton.tintColor = .classiBlue
        
        let profile = UIBarButtonItem(image: profileButton.image, style: .done, target: self, action: #selector(profileVC))
        let signout = UIBarButtonItem(image: signoutButton.image, style: .done, target: self, action: #selector(signoutUser))
        let signup = UIBarButtonItem(image: signupButton.image, style: .done, target: self, action: #selector(signupUser))
        
        if userID != nil {
            navigationItem.rightBarButtonItem = signout
        }
        else {
            navigationItem.rightBarButtonItem = signup
        }
        navigationItem.leftBarButtonItem = profile
    }
    
    func getUserFavourites() {
        // API CALl
    }
    
    @objc func profileVC() {
        if userID != nil {
            let destVC = ProfileVC()
            destVC.userID = userID
            let navController = UINavigationController(rootViewController: destVC)
            navController.navigationBar.isTranslucent = false
            navController.navigationBar.barTintColor = .classiBlue
            present(navController, animated: true)
        }
        else {
            self.presentClassiAlertOnMainThread(title: "Access Denied! Sign Up", message: "You cannot use that feature without signing up to the app.", buttonTitle: "Ok")
        }
    }
    
    @objc func viewCarVC() {
        let destVC = ViewCarVC()
        let navController = UINavigationController(rootViewController: destVC)
        navController.navigationBar.isTranslucent = false
        navController.navigationBar.backgroundColor = .classiBlue
        navController.navigationBar.prefersLargeTitles = true
        navController.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        present(navController, animated: true)
    }
    
    @objc func signoutUser() {
        let destVC = WelcomeVC()
        destVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    @objc func signupUser() {
        let destVC = SignUpVC()
        destVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    func customiseNavigationBar() {
        
        let app = UIApplication.shared
        let statusBarHeight: CGFloat = app.statusBarFrame.size.height
        
        let statusbarView = UIView()
        statusbarView.backgroundColor = .classiBlue
        view.addSubview(statusbarView)
        
        statusbarView.translatesAutoresizingMaskIntoConstraints = false
        statusbarView.heightAnchor
            .constraint(equalToConstant: statusBarHeight).isActive = true
        statusbarView.widthAnchor
            .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
        statusbarView.topAnchor
            .constraint(equalTo: view.topAnchor).isActive = true
        statusbarView.centerXAnchor
              .constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func configureUI() {
        
        infoLabel.text = "Swipe to delete the cars from your favourites. You will no longer see the cars here."
        infoLabel.numberOfLines = 0
        infoLabel.textAlignment = .center
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.font = UIFont(name: "HelveticaNeue", size: 17)
        infoLabel.textColor = .systemGray2
        
        view.addSubview(infoLabel)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 130
        tableView.isHidden = false
        tableView.register(ClassiCarCell.self, forCellReuseIdentifier: "myCell")
        
        view.addSubview(tableView)
        
        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
        
            infoLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            infoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            infoLabel.heightAnchor.constraint(equalToConstant: 40),
            
            tableView.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: padding),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: padding),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -padding),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding*2)
            
        ])
    }

}

extension FavouritesVC: UITableViewDataSource, UITableViewDelegate, FavouritedImage {
    
    func didFav(result: Int) {
        print("did fav")
    }
    
    func didUnFav(result: Int) {
        print("did un fav")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouritedCars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! ClassiCarCell
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        cell.update(image: "", name: "NO API YET", carPrice: "NO API YET", carYear: "NO API YET", row: indexPath.row)
        cell.myDelegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destVC = ViewCarVC()
        destVC.listing = favouritedCars[indexPath.row]
        destVC.userID = userID
        let navController = UINavigationController(rootViewController: destVC)
        navController.navigationBar.isTranslucent = false
        navController.navigationBar.backgroundColor = .classiBlue
        navController.navigationBar.prefersLargeTitles = true
        navController.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        present(navController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // make network call to remove rows
            self.tableView.beginUpdates()
            self.favouritedCars.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.endUpdates()
            self.tableView.reloadData()
        }
    }
    
        
}

