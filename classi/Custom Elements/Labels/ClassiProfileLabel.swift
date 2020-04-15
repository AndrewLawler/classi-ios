//
//  ClassiProfileLabel.swift
//  classi
//
//  Created by Andrew Lawler on 23/03/2020.
//  Copyright © 2020 andrewlawler. All rights reserved.
//

import UIKit

class ClassiProfileLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    convenience init(textInput: String, numOfLines: Int) {
        self.init(frame: .zero)
        numberOfLines = numOfLines
        text = textInput
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        textAlignment = .center
        font = UIFont(name: "HelveticaNeue-Bold", size: 35)
        textColor = .white
    }
}
