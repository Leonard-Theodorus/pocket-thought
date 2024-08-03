//
//  IdeasCell.swift
//  Pocket Thought
//
//  Created by Alonica🐦‍⬛🐺 on 08/07/24.
//

import UIKit

class IdeasCell: UITableViewCell {
    
    // MARK: -- Cell View Components --
    var ideaLabel : UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var plusButton : UIButton = {
        let button = UIButton(frame: .zero)
        button.tintColor = UIColor.systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var arrowImage : UIImageView = {
        let imageView = UIImageView(frame: .zero)
        let image = UIImage(systemName: "chevron.compact.down")
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var isExpanded : Bool = false
    
    var delegate : IdeasHeaderDelegate?
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints(){
        contentView.addSubview(ideaLabel)
        contentView.addSubview(plusButton)
        contentView.addSubview(arrowImage)
        ideaLabel.numberOfLines = 0
        contentView.layer.borderWidth = 0.5
        contentView.layer.borderColor = UIColor.black.cgColor
        plusButton.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        plusButton.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 18), forImageIn: .normal)
        let tapAction = UIAction { [weak self] _ in
            guard let self else {return}
            delegate?.plusButtonTapped(thought: ideaLabel.text!)
        }
        plusButton.addAction(tapAction, for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            ideaLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            ideaLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            ideaLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            plusButton.leadingAnchor.constraint(greaterThanOrEqualTo: ideaLabel.trailingAnchor, constant: 5),
            plusButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            plusButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            arrowImage.leadingAnchor.constraint(equalTo: plusButton.trailingAnchor, constant: 5),
            arrowImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            arrowImage.heightAnchor.constraint(equalToConstant: 22),
            arrowImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
        ])
        // MARK: Content Hugging; Higher: resisting expansion relative to instrinsic size
        ideaLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        ideaLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        // MARK: Content Compression Resistance: Higher: Supporting expansion / Rejects compression
        plusButton.setContentHuggingPriority(.defaultLow, for: .horizontal)
        plusButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }
    
    func update(animated : Bool){
        if animated {
            UIView.animate(withDuration: 0.3, animations: { [weak self] in
                guard let self else {return }
                self.arrowImage.transform = isExpanded ? CGAffineTransform(rotationAngle: .pi) : .identity
            })
        }
    }
}

