//
//  ClassiCarCell.swift
//  classi
//
//  Created by Andrew Lawler on 08/03/2020.
//  Copyright © 2020 andrewlawler. All rights reserved.
//

import UIKit

class ClassiCarCell: UITableViewCell {
    
    // UI Elements
    let carImage = UIImageView()
    let carName = ClassiBodyLabel(textAlignment: .left)
    let year = UIImageView()
    let price = UIImageView()
    let yearLabel = ClassiBodyLabel(textAlignment: .left)
    let priceLabel = ClassiBodyLabel(textAlignment: .left)
    let favourite = UIImageView()
    
    var isFavourited = false
    var indexPathRow: Int?
    var myDelegate: FavouritedImage?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(image: String, name: String, carPrice: String, carYear: String, row: Int, beenFavorited: Bool) {
        carImage.load(url: URL(string: image)!)
        carName.text = name
        priceLabel.text = carPrice
        yearLabel.text = carYear
        self.indexPathRow = row
        self.isFavourited = beenFavorited
        self.favourite.image = isFavourited ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
    }
    
    func configureFavImage() {
        favourite.translatesAutoresizingMaskIntoConstraints = false
        favourite.tintColor = .classiBlue
        favourite.image = isFavourited ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedFav))
        favourite.addGestureRecognizer(tap)
        favourite.isUserInteractionEnabled = true
    }
    
    @objc func tappedFav() {
        isFavourited.toggle()
        favourite.image = isFavourited ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        if isFavourited == true {
            myDelegate?.didFav(result: indexPathRow!)
        }
        else {
            myDelegate?.didUnFav(result: indexPathRow!)
        }
    }
    
    // custom Cell init
    private func configure() {
        
        // add subviews
        addSubview(carName)
        addSubview(year)
        addSubview(price)
        addSubview(yearLabel)
        addSubview(priceLabel)
        addSubview(favourite)
        
        // customise elements
        carName.font = UIFont(name: "Helvetica-Bold", size: 25)
        carName.textColor = .classiBlue
        carName.adjustsFontSizeToFitWidth = true
        
        carImage.contentMode = .scaleAspectFill
        carImage.translatesAutoresizingMaskIntoConstraints = false
        
        let carImageView = UIView()
        addSubview(carImageView)
        carImageView.addSubview(carImage)
        carImageView.layer.cornerRadius = 15
        carImageView.layer.masksToBounds = true
        carImageView.translatesAutoresizingMaskIntoConstraints = false
        carImageView.layer.borderWidth = 3
        carImageView.layer.borderColor = UIColor.classiBlue.cgColor
        
        year.image = UIImage(systemName: "calendar")
        year.translatesAutoresizingMaskIntoConstraints = false
        year.tintColor = .classiBlue
        
        price.image = UIImage(systemName: "sterlingsign.circle")
        price.translatesAutoresizingMaskIntoConstraints = false
        price.tintColor = .classiBlue
        
        yearLabel.font = UIFont(name: "Helvetica-Medium", size: 15)
        priceLabel.font = UIFont(name: "Helvetica-Medium", size: 15)
        
        configureFavImage()
        
        let padding: CGFloat = 10
        
        // constrain to the cell
        
        NSLayoutConstraint.activate([
            
            carImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            carImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: padding),
            carImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            carImageView.widthAnchor.constraint(equalToConstant: 160),
            
            carImage.centerYAnchor.constraint(equalTo: carImageView.centerYAnchor),
            carImage.centerXAnchor.constraint(equalTo: carImageView.centerXAnchor),
            carImage.widthAnchor.constraint(equalToConstant: 180),
            carImage.heightAnchor.constraint(equalToConstant: 120),
            
            carName.topAnchor.constraint(equalTo: carImageView.topAnchor, constant: 5),
            carName.leadingAnchor.constraint(equalTo: carImageView.trailingAnchor, constant: 10),
            carName.rightAnchor.constraint(equalTo: rightAnchor, constant: -padding),
            carName.heightAnchor.constraint(equalToConstant: 30),
            
            year.topAnchor.constraint(equalTo: carName.bottomAnchor, constant: 10),
            year.leadingAnchor.constraint(equalTo: carImageView.trailingAnchor, constant: 10),
            year.widthAnchor.constraint(equalToConstant: 25),
            year.heightAnchor.constraint(equalToConstant: 25),
            
            price.topAnchor.constraint(equalTo: year.bottomAnchor, constant: 10),
            price.leadingAnchor.constraint(equalTo: carImageView.trailingAnchor, constant: 10),
            price.widthAnchor.constraint(equalToConstant: 25),
            price.heightAnchor.constraint(equalToConstant: 25),
            
            yearLabel.topAnchor.constraint(equalTo: carName.bottomAnchor, constant: 13),
            yearLabel.leadingAnchor.constraint(equalTo: year.trailingAnchor, constant: 10),
            yearLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -padding),
            yearLabel.heightAnchor.constraint(equalToConstant: 20),
            
            priceLabel.topAnchor.constraint(equalTo: year.bottomAnchor, constant: 13),
            priceLabel.leadingAnchor.constraint(equalTo: price.trailingAnchor, constant: 10),
            priceLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -padding),
            priceLabel.heightAnchor.constraint(equalToConstant: 20),
            
            favourite.topAnchor.constraint(equalTo: price.topAnchor),
            favourite.rightAnchor.constraint(equalTo: rightAnchor, constant: -padding-6),
            favourite.heightAnchor.constraint(equalToConstant: 20),
            favourite.widthAnchor.constraint(equalToConstant: 20)
        ])
        
    }

}
