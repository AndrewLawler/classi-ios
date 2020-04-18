//
//  ProfileVC.swift
//  classi
//
//  Created by Andrew Lawler on 08/03/2020.
//  Copyright © 2020 andrewlawler. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let headerView = UIView()
    let tableView = UITableView(frame: .zero, style: .grouped)
    let tableInfoLabel = UILabel()
    
    var userID: Auth?
    var yourCars: [Listing] = []
    var mainImg: Data?
    
    var user: User?
    
    var myDelegate: FromModal?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        setupNav()
        getUserInfo()
        setupProfile()
        view.backgroundColor = .white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getUserInfo()
    }
    
    func getUserInfo(){
        print(userID!.user.id)
        NetworkManager.shared.getUser(id: userID!.user.id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case.success(let user):
                DispatchQueue.main.async {
                    let topVC = TopProfileVC(name: user.name, bio: user.email + "\n" + user.registerDate.prefix(10), id: self.userID!, img: user.avatarUrl!)
                    topVC.myDelegate = self
                    self.add(childVC: topVC, to: self.headerView)
                    self.user = user
                }
            case.failure(let error):
                print(error.rawValue)
            }
        }
        
        NetworkManager.shared.getUsersCars(user: userID!.user.id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case.success(let cars):
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.yourCars = cars
                    self.tableView.reloadData()
                    self.configureEmptyView()
                }
            case.failure(let error):
                DispatchQueue.main.async {
                    self.configureEmptyView()
                }
                print(error.rawValue)
            }
        }
            
    }
    
    func setupNav() {
        
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editProfileVC))
        editButton.tintColor = .white
        navigationItem.rightBarButtonItem = editButton
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        doneButton.tintColor = .white
        navigationItem.leftBarButtonItem = doneButton
    }
    
    @objc func dismissVC() {
        myDelegate?.fromModal(answer: true)
        dismiss(animated: true)
    }
    
    @objc func editProfileVC() {
        let destVC = EditProfileVC()
        destVC.userID = userID
        destVC.user = self.user
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
    
    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    
    func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.pinToEdges(of: view)
        contentView.pinToEdges(of: scrollView)
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 800)
        ])
    }
    
    func configureEmptyView() {
        let emptyState = UIView()
        let emptyStateLabel = ClassiProfileLabel(textInput: "You have no 🚙 please list one.", numOfLines: 1)
        let emptyStateImage = UIImageView()
        
        emptyStateLabel.textColor = .classiBlue
        emptyStateLabel.adjustsFontSizeToFitWidth = true
        emptyState.translatesAutoresizingMaskIntoConstraints = false
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyStateImage.tintColor = .classiBlue
        emptyStateImage.translatesAutoresizingMaskIntoConstraints = false
        emptyStateImage.image = UIImage(systemName: "car")
        
        contentView.addSubview(emptyState)
        emptyState.addSubview(emptyStateLabel)
        emptyState.addSubview(emptyStateImage)
        
        let padding: CGFloat = 10
        
        NSLayoutConstraint.activate([
            emptyState.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            emptyState.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            emptyState.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            emptyState.heightAnchor.constraint(equalToConstant: 180),
            
            emptyStateLabel.topAnchor.constraint(equalTo: emptyState.topAnchor, constant: padding),
            emptyStateLabel.leadingAnchor.constraint(equalTo: emptyState.leadingAnchor, constant: padding),
            emptyStateLabel.trailingAnchor.constraint(equalTo: emptyState.trailingAnchor, constant: -padding),
            emptyStateLabel.heightAnchor.constraint(equalToConstant: 80),
            
            emptyStateImage.topAnchor.constraint(equalTo: emptyStateLabel.bottomAnchor, constant: padding),
            emptyStateImage.centerXAnchor.constraint(equalTo: emptyState.centerXAnchor),
            emptyStateImage.widthAnchor.constraint(equalToConstant: 100),
            emptyStateImage.heightAnchor.constraint(equalToConstant: 80)
        ])
    
        if yourCars.count == 0 {
            tableInfoLabel.text = ""
            tableView.isHidden = true
            emptyState.isHidden = false
            emptyStateLabel.isHidden = false
            emptyStateImage.isHidden = false
        }
        else {
            tableInfoLabel.text = "Swipe a car to delete it's listing."
            tableView.isHidden = false
            emptyState.isHidden = true
            emptyStateLabel.isHidden = true
            emptyStateImage.isHidden = true
        }
    }
    
    func setupProfile() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(headerView)
        contentView.addSubview(tableView)
        contentView.addSubview(tableInfoLabel)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 130
        tableView.isHidden = false
        tableView.register(ClassiCarProfileCell.self, forCellReuseIdentifier: "myCell")
        
        tableInfoLabel.font = UIFont(name: "HelveticaNeue-italic", size: 15)
        tableInfoLabel.textColor = .systemGray2
        tableInfoLabel.textAlignment = .center
        tableInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 412),
            
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            tableView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: padding),
            tableView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -padding),
            tableView.heightAnchor.constraint(equalToConstant: 300),
            
            tableInfoLabel.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 10),
            tableInfoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tableInfoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tableInfoLabel.heightAnchor.constraint(equalToConstant: 15),
        ])
    }
    
}

extension ProfileVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return yourCars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! ClassiCarProfileCell
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        cell.update(image: (yourCars[indexPath.row].photos?.first)!, name: "\((yourCars[indexPath.row].car.make ?? "Make") + " " + (yourCars[indexPath.row].car.model ?? "Model"))" , carPrice: "\(yourCars[indexPath.row].price)" , carYear: "\(yourCars[indexPath.row].car.year ?? 0)")
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let tableViewHeaderView = UIView()
        let yourListingLabel = UILabel()
        yourListingLabel.text = "Your Listings"
        yourListingLabel.font = UIFont(name: "Helvetica-Bold", size: 15)
        yourListingLabel.textColor = .classiBlue
        yourListingLabel.translatesAutoresizingMaskIntoConstraints = false
        yourListingLabel.textAlignment = .left
        tableViewHeaderView.addSubview(yourListingLabel)
        NSLayoutConstraint.activate([
            yourListingLabel.topAnchor.constraint(equalTo: tableViewHeaderView.topAnchor),
            yourListingLabel.leadingAnchor.constraint(equalTo: tableViewHeaderView.leadingAnchor, constant: 20),
            yourListingLabel.heightAnchor.constraint(equalToConstant: 20),
            yourListingLabel.widthAnchor.constraint(equalToConstant: 100)
        ])
        return tableViewHeaderView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destVC = ViewCarVC()
        destVC.listing = yourCars[indexPath.row]
        destVC.userID = userID
        let navController = UINavigationController(rootViewController: destVC)
        navController.navigationBar.isTranslucent = false
        navController.navigationBar.backgroundColor = .classiBlue
        navController.navigationBar.prefersLargeTitles = true
        navController.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        let headerAppearance = editAppearance()
        navController.navigationBar.scrollEdgeAppearance = headerAppearance
        navController.navigationBar.standardAppearance = headerAppearance
        present(navController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            NetworkManager.shared.deleteListing(token: userID!.token, id: yourCars[indexPath.row]._id) { [weak self] result in
                guard let self = self else { return }
                switch result {
                    case.success(let cars):
                        DispatchQueue.main.async {
                            self.presentClassiAlertOnMainThread(title: "Car Deleted", message: "You have deleted \(self.yourCars[indexPath.row].car.make! + " " + self.yourCars[indexPath.row].car.model!) from the marketplace.", buttonTitle: "Ok")
                            self.tableView.beginUpdates()
                            self.yourCars.remove(at: indexPath.row)
                            self.tableView.deleteRows(at: [indexPath], with: .fade)
                            self.tableView.endUpdates()
                            self.tableView.reloadData()
                            self.configureEmptyView()
                        }
                    case.failure(let error):
                        print(error.rawValue)
                }
            }
        }
    }
    
}

extension ProfileVC: InnerChild {
    
    func fromChild(answer: Bool) {
        if answer == true {
            getUserInfo()
        }
    }
    
    
}

