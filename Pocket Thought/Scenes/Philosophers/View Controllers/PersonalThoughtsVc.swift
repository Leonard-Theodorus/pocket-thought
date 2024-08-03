//
//  PersonalThoughtsVc.swift
//  Pocket Thought
//
//  Created by Alonica🐦‍⬛🐺 on 15/07/24.
//

import UIKit

class PersonalThoughtsVc: UIViewController {
    
    // MARK: -- View Components --
    var thoughtsHeader : ThoughtsHeader = {
        let view = ThoughtsHeader(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var thoughtsTextField : UITextView = {
        let textView = UITextView(frame: .zero)
        textView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner] // Bottom left and right
        textView.layer.cornerRadius = 16
        textView.layer.borderWidth = 0.5
        textView.layer.borderColor = UIColor.red.cgColor
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.backgroundColor = .clear
        return textView
    }()
    
    var placeholderLabel : UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "My personal thoughts"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        return label
    }()
    
    var editMode : Bool = false
    
    var currentThoughtSnapshot : PersonalThoughtDataBaseModel!
    
    // MARK: -- ViewModels --
    var viewModel : PersonalThoughtViewModelInputDelegate! {
        didSet{
            viewModel.viewDelegate = self
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Thoughts"
        setupToolBar()
        setupConstraints()
        thoughtsTextField.delegate = self
    }
    
    private func setupToolBar(){
        let cancelBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        let addThoughtsButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
        navigationItem.leftBarButtonItem = cancelBarButtonItem
        navigationItem.rightBarButtonItem = addThoughtsButtonItem
    }
    
    private func setupConstraints() {
        view.addSubview(thoughtsHeader)
        view.addSubview(thoughtsTextField)
        thoughtsTextField.addSubview(placeholderLabel)
        
        NSLayoutConstraint.activate([
            thoughtsHeader.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            thoughtsHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            thoughtsHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            thoughtsTextField.topAnchor.constraint(greaterThanOrEqualTo: thoughtsHeader.bottomAnchor),
            thoughtsTextField.leadingAnchor.constraint(equalTo: thoughtsHeader.leadingAnchor),
            thoughtsTextField.trailingAnchor.constraint(equalTo: thoughtsHeader.trailingAnchor),
            thoughtsTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            placeholderLabel.topAnchor.constraint(equalTo: thoughtsTextField.topAnchor, constant: 8),
            placeholderLabel.leadingAnchor.constraint(equalTo: thoughtsTextField.leadingAnchor, constant: 5),
            placeholderLabel.trailingAnchor.constraint(equalTo: thoughtsTextField.trailingAnchor, constant: -5),
        ])
        
        updatePlaceHolderAndSaveButtonVisibility()
    }
    
    private func updatePlaceHolderAndSaveButtonVisibility(){
        navigationItem.rightBarButtonItem?.isEnabled = !thoughtsTextField.text.isEmpty
        placeholderLabel.isHidden = !thoughtsTextField.text.isEmpty
    }
    
    @objc private func cancelButtonTapped(){
        dismiss(animated: true)
    }
    
    @objc private func saveButtonTapped(){
        if editMode {
            viewModel.editThought(philosopherItem: viewModel.getPhilosopher(), ideaItem: viewModel.getIdea(), existingThought: currentThoughtSnapshot, thoughtContent: thoughtsTextField.text)
        }
        else {
            viewModel.saveThought(philosopherItem: viewModel.getPhilosopher(), ideaItem: viewModel.getIdea(), thoughtContent: thoughtsTextField.text)
        }
        dismiss(animated: true)
    }

}

extension PersonalThoughtsVc : UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        updatePlaceHolderAndSaveButtonVisibility()
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
}

extension PersonalThoughtsVc : PersonalThoughtViewModelViewDelegate{
    
}
