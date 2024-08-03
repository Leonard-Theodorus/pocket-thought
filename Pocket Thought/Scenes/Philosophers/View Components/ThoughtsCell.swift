//
//  ThoughtsCell.swift
//  Pocket Thought
//
//  Created by Alonica🐦‍⬛🐺 on 23/07/24.
//

import UIKit

class ThoughtsCell: UITableViewCell {
    
    var thoughtLabel : UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var editButton : UIButton = {
        let button = UIButton(frame: .zero)
        let editImage = UIImage(systemName: "pencil")
        button.setImage(editImage, for: .normal)
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 20), forImageIn: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var deleteButton: UIButton = {
        let button = UIButton(frame: .zero)
        let editImage = UIImage(systemName: "trash")
        button.setImage(editImage, for: .normal)
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 20), forImageIn: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var idea : String = ""
    
    weak var delegate : ThoughtsCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupConstraints () {
        contentView.addSubview(thoughtLabel)
        contentView.addSubview(editButton)
        contentView.addSubview(deleteButton)
        
        thoughtLabel.numberOfLines = 0
        
        let editAction = UIAction { [weak self] _ in
            guard let self else {return }
            delegate?.didTapEdit(idea: idea, thought: thoughtLabel.text!)
        }
        editButton.addAction(editAction, for: .touchUpInside)
        
        let deleteAction = UIAction { [weak self] _ in
            guard let self else {return }
            delegate?.didTapDelete(idea : idea, thought: thoughtLabel.text!)
        }
        deleteButton.addAction(deleteAction, for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            thoughtLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            thoughtLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
            editButton.leadingAnchor.constraint(greaterThanOrEqualTo: thoughtLabel.trailingAnchor),
            editButton.centerYAnchor.constraint(equalTo: thoughtLabel.centerYAnchor),
            deleteButton.leadingAnchor.constraint(equalTo: editButton.trailingAnchor, constant: 5),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            deleteButton.centerYAnchor.constraint(equalTo: editButton.centerYAnchor)
        ])
    }

}

protocol ThoughtsCellDelegate : AnyObject {
    func didTapEdit(idea : String, thought : String)
    func didTapDelete(idea : String, thought : String)
}
