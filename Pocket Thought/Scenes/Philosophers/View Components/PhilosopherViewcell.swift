//
//  PhilosopherViewcell.swift
//  Pocket Thought
//
//  Created by Alonica🐦‍⬛🐺 on 06/07/24.
//

import UIKit

class PhilosopherViewcell: UICollectionViewCell {
    var philosopherImageView : UIImageView!
    var nameCard : PhilosopherNameCard = {
        let nameCard = PhilosopherNameCard(frame: .zero)
        nameCard.translatesAutoresizingMaskIntoConstraints = false
        return nameCard
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.philosopherImageView = UIImageView(frame: .zero)
        self.philosopherImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner] // top- left and right
        self.philosopherImageView.layer.cornerRadius = 16
        self.philosopherImageView.clipsToBounds = true
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints(){
        philosopherImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(philosopherImageView)
        contentView.addSubview(nameCard)
        
        NSLayoutConstraint.activate([
            philosopherImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            philosopherImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            philosopherImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            nameCard.topAnchor.constraint(equalTo: philosopherImageView.bottomAnchor),
            nameCard.leadingAnchor.constraint(equalTo: philosopherImageView.leadingAnchor),
            nameCard.trailingAnchor.constraint(equalTo: philosopherImageView.trailingAnchor),
            nameCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.philosopherImageView.image = nil
        self.nameCard.philosopherNameLabel.text = nil
    }
}
