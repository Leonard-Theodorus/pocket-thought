//
//  PhilosopherNameCard.swift
//  Pocket Thought
//
//  Created by Alonica🐦‍⬛🐺 on 08/07/24.
//

import UIKit

class PhilosopherNameCard: UIView {
    
    var philosopherNameLabel : UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.philosopherNameLabel = UILabel(frame: .zero)
        self.philosopherNameLabel.textAlignment = .center
        self.philosopherNameLabel.numberOfLines = 0
        self.philosopherNameLabel.textColor = .darkText
        self.layer.cornerRadius = 16
        self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner] // Bottom-left and right
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 0.5
        setupConstraints()
    }
    
    private func setupConstraints(){
        philosopherNameLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(philosopherNameLabel)
        
        NSLayoutConstraint.activate([
            philosopherNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            philosopherNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            philosopherNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            philosopherNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
