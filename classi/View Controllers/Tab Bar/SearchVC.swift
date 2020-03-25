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
    
    var isSearching = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        getListings()
        customiseNavigationBar()
        configureSearchController()
        configureSegmentedController()
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
            case.success(let topListingArray):
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.highlightedListing = topListingArray
                    self.tableView.reloadData()
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
        borderView.addSubview(specialLabel)
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
        highlightTableView.register(ClassiCarCell.self, forCellReuseIdentifier: "myCell")
        
        view.addSubview(borderView)

        specialLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 30)
        specialLabel.textColor = .classiBlue
        
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
            borderView.heightAnchor.constraint(equalToConstant: 195),
            
            specialLabel.topAnchor.constraint(equalTo: borderView.topAnchor, constant: 10),
            specialLabel.leadingAnchor.constraint(equalTo: borderView.leadingAnchor, constant: 10),
            specialLabel.trailingAnchor.constraint(equalTo: borderView.trailingAnchor, constant: -10),
            specialLabel.heightAnchor.constraint(equalToConstant: 35),
            
            highlightTableView.topAnchor.constraint(equalTo: specialLabel.bottomAnchor, constant: 10),
            highlightTableView.leftAnchor.constraint(equalTo: borderView.leftAnchor, constant: 10),
            highlightTableView.rightAnchor.constraint(equalTo: borderView.rightAnchor, constant: -10),
            highlightTableView.heightAnchor.constraint(equalToConstant: 130),
            
            tableView.topAnchor.constraint(equalTo: borderView.bottomAnchor, constant: padding),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: padding),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -padding),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding*2)
        
        ])
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
            filteredListings = ourListings.filter { ($0.car.make.lowercased() + " " + $0.car.model.lowercased()).contains(filter.lowercased())  }
        }
        else if currentSegment == "Year" {
            filteredListings = ourListings.filter { (String($0.car.year)).contains(filter.lowercased())  }
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
            filteredListings = ourListings.filter { ($0.car.make.lowercased() + " " + $0.car.model.lowercased()).contains(filter.lowercased())  }
        }
        else if currentSegment == "Year" {
            filteredListings = ourListings.filter { (String($0.car.year)).contains(filter.lowercased())  }
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
        let activeArray = isSearching ? filteredListings : ourListings
        print("did fav \(activeArray[result].car.make + " " + activeArray[result].car.model)")
    }
    
    func didUnFav(result: Int) {
        let activeArray = isSearching ? filteredListings : ourListings
        print("did un fav \(activeArray[result].car.make + " " + activeArray[result].car.model)")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            let activeArray = isSearching ? filteredListings : ourListings
            return activeArray.count
        }
        else {
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! ClassiCarCell
            cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
            let activeArray = isSearching ? filteredListings : ourListings
            cell.update(image: "", name: "\(activeArray[indexPath.row].car.make + " " + activeArray[indexPath.row].car.model)", carPrice: "\(activeArray[indexPath.row].price)", carYear: "\(activeArray[indexPath.row].car.year)", row: indexPath.row)
            cell.myDelegate = self
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! ClassiCarCell
            cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
            //cell.update(image: "", name: "\(highlightedListing[indexPath.row].car.make + " " + highlightedListing[indexPath.row].car.model)", carPrice: "\(highlightedListing[indexPath.row].price)", carYear: "\(highlightedListing[indexPath.row].car.year)")
            cell.update(image: "", name: "name", carPrice: "price", carYear: "year", row: indexPath.row)
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



