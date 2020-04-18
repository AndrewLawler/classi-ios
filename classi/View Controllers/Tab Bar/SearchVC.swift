//
//  SearchVC.swift
//  classi
//
//  Created by Andrew Lawler on 08/03/2020.
//  Copyright © 2020 andrewlawler. All rights reserved.
//

import UIKit

class SearchVC: UIViewController {
    
    var userID: Auth?
    
    var segmentedControl: UISegmentedControl!
    let listCarLabel = UILabel()
    let tableView = UITableView()
    let specialLabel = ClassiProfileLabel(textInput: "Hottest Listing", numOfLines: 1)
    let highlightTableView = UITableView()
    
    var highlightedListing: [Listing] = []
    var ourListings: [Listing] = []
    var filteredListings: [Listing] = []
    var userFavorites: [String] = []
    
    var isSearching = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        getListings()
        customiseNavigationBar()
        configureSearchController()
        configureSegmentedController()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getListings()
        
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
    
    @objc func profileVC() {
        if userID != nil {
            let destVC = ProfileVC()
            destVC.userID = userID
            destVC.myDelegate = self
            let navController = UINavigationController(rootViewController: destVC)
            let headerAppearance = editAppearance()
            navController.navigationBar.scrollEdgeAppearance = headerAppearance
            navController.navigationBar.standardAppearance = headerAppearance
            navController.navigationBar.isTranslucent = false
            present(navController, animated: true)
        }
        else {
            self.presentClassiAlertOnMainThread(title: "Access Denied! Sign Up", message: "You cannot use that feature without signing up to the app.", buttonTitle: "Ok")
        }
    }
    
    func editAppearance() -> UINavigationBarAppearance {
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithOpaqueBackground()
        coloredAppearance.backgroundColor = .classiBlue
        coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        return coloredAppearance
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
    
    func getListings() {
        if userID != nil {
            NetworkManager.shared.getUser(id: userID!.user.id) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let user):
                    DispatchQueue.main.async {
                        self.userFavorites = user.favorites
                        self.tableView.reloadData()
                        self.highlightTableView.reloadData()
                    }
                case .failure(let error):
                    print(error.rawValue)
                }
            }
        }
        
        NetworkManager.shared.getAllListings { [weak self] result in
            guard let self = self else { return }
            switch result {
            case.success(let listingArray):
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.ourListings = listingArray
                    self.tableView.reloadData()
                }
            case.failure(let error):
                print(error.rawValue)
            }
        }
        
        NetworkManager.shared.getTopListing { [weak self] result in
            guard let self = self else { return }
            switch result {
            case.success(let topListing):
                DispatchQueue.main.async {
                    self.highlightTableView.reloadData()
                    self.highlightedListing = topListing
                    self.highlightTableView.reloadData()
                }
            case.failure(let error):
                print(error.rawValue)
            }
        }
    }
    
    @objc func listCar() {
        if userID != nil {
            let destVC = ListCarVC()
            destVC.userID = userID
            destVC.myDelegate = self
            let navController = UINavigationController(rootViewController: destVC)
            navController.navigationBar.isTranslucent = false
            navController.navigationBar.backgroundColor = .classiBlue
            navController.navigationBar.prefersLargeTitles = true
            navController.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            navController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
            present(navController, animated: true)
        }
        else {
            self.presentClassiAlertOnMainThread(title: "Access Denied! Sign Up", message: "You cannot use that feature without signing up to the app.", buttonTitle: "Ok")
        }
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
    
    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for your ideal car."
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = .white
        navigationItem.searchController = searchController
    }
    
    func configureSegmentedController() {
        
        let items = ["Name", "Max Price", "Year"]
        segmentedControl = UISegmentedControl(items: items)
        
        let textAttribute = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let textAttribute2 = [NSAttributedString.Key.foregroundColor: UIColor.classiBlue]
        
        segmentedControl.setTitleTextAttributes(textAttribute, for: .normal)
        segmentedControl.setTitleTextAttributes(textAttribute2, for: .selected)
        
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.layer.cornerRadius = 2
        segmentedControl.selectedSegmentTintColor = .white
        segmentedControl.backgroundColor = .classiBlue
        segmentedControl.layer.masksToBounds = true
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
    }
    
    func configureUI() {
        
        listCarLabel.textAlignment = .center
        listCarLabel.translatesAutoresizingMaskIntoConstraints = false
        listCarLabel.adjustsFontSizeToFitWidth = true
        
        let attributedString = NSMutableAttributedString(string: "Click here to list your own car on the marketplace.", attributes: [
          .font: UIFont(name: "HelveticaNeue", size: 15),
          .foregroundColor: UIColor.systemGray2
        ])
        attributedString.addAttributes([
          .font: UIFont(name: "HelveticaNeue-Bold", size: 15),
          .foregroundColor: UIColor.classiBlue
        ], range: NSRange(location: 6, length: 4))
        
        listCarLabel.attributedText = attributedString
        listCarLabel.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(listCar))
        listCarLabel.addGestureRecognizer(tap)
        
        view.addSubview(listCarLabel)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 130
        tableView.isHidden = false
        tableView.register(ClassiCarCell.self, forCellReuseIdentifier: "myCell")
        
        view.addSubview(tableView)
        
        let borderView = UIView()
        borderView.addSubview(highlightTableView)
        borderView.translatesAutoresizingMaskIntoConstraints = false
        borderView.layer.cornerRadius = 15
        borderView.layer.borderColor = UIColor.classiBlue.cgColor
        borderView.layer.borderWidth = 3
        
        highlightTableView.dataSource = self
        highlightTableView.delegate = self
        highlightTableView.allowsSelection = true
        highlightTableView.translatesAutoresizingMaskIntoConstraints = false
        highlightTableView.rowHeight = 130
        highlightTableView.isHidden = false
        highlightTableView.register(ClassiCarCell.self, forCellReuseIdentifier: "myCell2")
        
        view.addSubview(borderView)
        
        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            segmentedControl.heightAnchor.constraint(equalToConstant: 40),
            
            listCarLabel.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: padding),
            listCarLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            listCarLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            listCarLabel.heightAnchor.constraint(equalToConstant: 20),
            
            borderView.topAnchor.constraint(equalTo: listCarLabel.bottomAnchor, constant: padding),
            borderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            borderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            borderView.heightAnchor.constraint(equalToConstant: 150),
            
            highlightTableView.topAnchor.constraint(equalTo: borderView.topAnchor, constant: 10),
            highlightTableView.leftAnchor.constraint(equalTo: borderView.leftAnchor, constant: 10),
            highlightTableView.rightAnchor.constraint(equalTo: borderView.rightAnchor, constant: -10),
            highlightTableView.heightAnchor.constraint(equalToConstant: 130),
            
            tableView.topAnchor.constraint(equalTo: borderView.bottomAnchor, constant: padding),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: padding),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -padding),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
        
        ])
    }
    
    func isListingFavorited(listingID: String) -> Bool {
    
        if userFavorites.contains(listingID) {
            return true
        } else {
            return false
        }
    }
    
}

extension SearchVC: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        let currentSegment = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)
    
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            isSearching = false
            tableView.reloadData()
            return
        }
        isSearching = true
        if currentSegment == "Max Price" {
            filteredListings = ourListings.filter { $0.price <= Int(filter)! ? true : false }
        }
        else if currentSegment == "Name" {
            filteredListings = ourListings.filter { ($0.car.make!.lowercased() + " " + $0.car.model!.lowercased()).contains(filter.lowercased())  }
        }
        else if currentSegment == "Year" {
            filteredListings = ourListings.filter { (String($0.car.year ?? 0)).contains(filter.lowercased())  }
        }
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let currentSegment = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)
        guard let filter = searchBar.text, !filter.isEmpty else { return }
        isSearching = true
        if currentSegment == "Max Price" {
            filteredListings = ourListings.filter { $0.price <= Int(filter)! ? true : false }
        }
        else if currentSegment == "Name" {
            filteredListings = ourListings.filter { ($0.car.make!.lowercased() + " " + $0.car.model!.lowercased()).contains(filter.lowercased())  }
        }
        else if currentSegment == "Year" {
            filteredListings = ourListings.filter { (String($0.car.year ?? 0)).contains(filter.lowercased())  }
        }
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        tableView.reloadData()
    }
    
}

extension SearchVC: UITableViewDataSource, UITableViewDelegate, FavouritedImage {
    
    func didFav(result: Int) {
        if userID != nil {
            let activeArray = isSearching ? filteredListings : ourListings
            NetworkManager.shared.favoriteListing(token: userID!.token, listing: activeArray[result]._id) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let msg):
                    print("Favorited:", msg.msg)
                case .failure(let err):
                    print("Error Message:", err.rawValue)
                }
            }
        }
        else {
            self.presentClassiAlertOnMainThread(title: "Access Denied! Sign Up", message: "You cannot use that feature without signing up to the app.", buttonTitle: "Ok")
        }
        
    }
    
    func didUnFav(result: Int) {
        if userID != nil {
            let activeArray = isSearching ? filteredListings : ourListings
            NetworkManager.shared.unFavoriteListing(token: userID!.token, listing: activeArray[result]._id) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let msg):
                    print("Unfavorited", msg.msg)
                case .failure(let err):
                    print(err.rawValue)
                }
            }
        }
        else {
            self.presentClassiAlertOnMainThread(title: "Access Denied! Sign Up", message: "You cannot use that feature without signing up to the app.", buttonTitle: "Ok")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            let activeArray = isSearching ? filteredListings : ourListings
            return activeArray.count
        }
        else {
            return highlightedListing.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! ClassiCarCell
            cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
            let activeArray = isSearching ? filteredListings : ourListings
            cell.update(image: (activeArray[indexPath.row].photos?.first!)!, name: "\((activeArray[indexPath.row].car.make ?? "Make") + " " + (activeArray[indexPath.row].car.model ?? "Model"))" , carPrice: "\(activeArray[indexPath.row].price)" , carYear: "\(activeArray[indexPath.row].car.year ?? 0)" , row: indexPath.row, beenFavorited: isListingFavorited(listingID: activeArray[indexPath.row]._id))
            cell.myDelegate = self
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "myCell2", for: indexPath) as! ClassiCarCell
            cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
            cell.update(image: (highlightedListing[indexPath.row].photos?.first!)!, name: "\((highlightedListing[indexPath.row].car.make ?? "Make") + " " + (highlightedListing[indexPath.row].car.model ?? "Model"))" , carPrice: "\(highlightedListing[indexPath.row].price)" , carYear: "\(highlightedListing[indexPath.row].car.year ?? 0)" , row: indexPath.row, beenFavorited: isListingFavorited(listingID: highlightedListing[indexPath.row]._id))
            cell.myDelegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableView {
            let destVC = ViewCarVC()
            let activeArray = isSearching ? filteredListings : ourListings
            destVC.listing = activeArray[indexPath.row]
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
        else if tableView == highlightTableView {
            let destVC = ViewCarVC()
            destVC.listing = highlightedListing[indexPath.row]
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
    }
    
}

extension SearchVC: FromModal {
    
    func fromModal(answer: Bool) {
        if answer == true {
            getListings()
        }
    }
    
}



