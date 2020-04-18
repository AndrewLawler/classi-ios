//
//  ReportListingVC.swift
//  classi
//
//  Created by Andrew Lawler on 09/03/2020.
//  Copyright © 2020 andrewlawler. All rights reserved.
//

import UIKit

class ReportListingVC: UIViewController {
    
    let reportLabel = UILabel()
    let reportButton = ClassiButton(backgroundColor: .classiBlue, title: "Report Listing", textColor: .white, borderColour: .classiBlue)
    
    var listing: Listing!
    var userID: Auth?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configure()
    }
    
    @objc func reported() {
        if userID != nil {
            NetworkManager.shared.reportListing(listing: listing._id) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let resp):
                    print(resp)
                    self.presentClassiAlertOnMainThread(title: "Reported Listing", message: "You have reported this listing of a \(self.listing.car.make ?? "N.A") \(self.listing.car.model ?? "N.A")", buttonTitle: "Ok")
                case .failure(let err):
                    self.presentClassiAlertOnMainThread(title: "Error Reporting", message: "There has been an error reporting this listing", buttonTitle: "Ok")
                }
            }
        }
        else {
            self.presentClassiAlertOnMainThread(title: "Access Denied! Sign Up", message: "You cannot use that feature without signing up to the app.", buttonTitle: "Ok")
        }
    }
    
    init(listing: Listing, id: Auth?) {
        super.init(nibName: nil, bundle: nil)
        self.listing = listing
        self.userID = id
        view.backgroundColor = .white
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        
        reportLabel.text = "If this listing is deemed as strange, please report this listing so our team can take a look!"
        reportLabel.translatesAutoresizingMaskIntoConstraints = false
        reportLabel.textAlignment = .center
        reportLabel.numberOfLines = 0
        reportLabel.font = UIFont(name: "HelveticaNeue", size: 15)
        reportLabel.textColor = .systemGray2
        
        view.addSubview(reportLabel)
        view.addSubview(reportButton)
        
        reportButton.addTarget(self, action: #selector(reported), for: .touchUpInside)
        
        let padding: CGFloat = 20
        let labelPadding: CGFloat = 25
        let buttonPadding: CGFloat = 70
        
        NSLayoutConstraint.activate([
            
            reportLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            reportLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            reportLabel.heightAnchor.constraint(equalToConstant: 40),
            reportLabel.widthAnchor.constraint(equalToConstant: 350),
            
            reportButton.topAnchor.constraint(equalTo: reportLabel.bottomAnchor, constant: padding),
            reportButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            reportButton.widthAnchor.constraint(equalToConstant: 300),
            reportButton.heightAnchor.constraint(equalToConstant: 60),
        
        ])
        
    }
    

}
