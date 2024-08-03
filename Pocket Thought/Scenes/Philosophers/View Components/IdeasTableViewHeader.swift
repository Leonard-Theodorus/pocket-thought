//
//  IdeasTableViewHeader.swift
//  Pocket Thought
//
//  Created by Alonica🐦‍⬛🐺 on 25/07/24.
//

import UIKit

class IdeasTableViewHeader: UITableViewHeaderFooterView{
    
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
    
    var delegate : IdeasHeaderDelegate?
    var isExpanded : Bool = false
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupConstraints()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(expandCollapseAction(_:)))
        addGestureRecognizer(tapGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints(){
        contentView.addSubview(ideaLabel)
        contentView.addSubview(plusButton)
        contentView.addSubview(arrowImage)
        ideaLabel.numberOfLines = 0
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.black.cgColor
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
    
    @objc func expandCollapseAction (_ sender : UITapGestureRecognizer) {
        guard let cell = sender.view as? IdeasTableViewHeader else {return}
        guard let section = sender.view?.tag else {return}
        cell.isExpanded = !cell.isExpanded
        cell.update(animated: true)
        delegate?.toggleSection(cell, section: section)
    }
    
    
    func update(animated : Bool){
        if animated {
            arrowImage.rotate()
        }
    }
    
    
    
}

extension UIView {
    
    func rotate() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 1
        rotation.isCumulative = true
//        rotation.repeatCount = Float.greatestFiniteMagnitude
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
    
}

protocol IdeasHeaderDelegate : AnyObject {
    func plusButtonTapped(thought : String)
    func toggleSection(_ header : IdeasTableViewHeader, section : Int)
}
