//
//  ThoughtsHeader.swift
//  Pocket Thought
//
//  Created by Alonica🐦‍⬛🐺 on 09/07/24.
//

import UIKit

class ThoughtsHeader: UIView {
    
    lazy var thoughtLabel : UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints(){
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.red.cgColor
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner] // Top-left top-right mask
        self.layer.cornerRadius = 16
        thoughtLabel.numberOfLines = 0
        addSubview(thoughtLabel)
        
        NSLayoutConstraint.activate([
            thoughtLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            thoughtLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            thoughtLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            thoughtLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    
}
