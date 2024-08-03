//
//  PhilosopherDetailVc.swift
//  Pocket Thought
//
//  Created by Alonica🐦‍⬛🐺 on 08/07/24.
//

import UIKit

class PhilosopherDetailVc: UIViewController {
    
    // MARK: -- View Components --
    var philosopherImageView : UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var philosopherShortDescription : UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var ideasTableView : UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ThoughtsCell.self, forCellReuseIdentifier: "t-cell")
        tableView.register(IdeasTableViewHeader.self, forHeaderFooterViewReuseIdentifier: "header")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.sectionHeaderTopPadding = 5
        return tableView
    }()
    
    // MARK: -- ViewModels --
    var viewModel : PhilosopherDetailInputDelegate! {
        didSet{
            viewModel.viewDelegate = self
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = viewModel.philosopherName()
        setupContents()
        setupConstraints()
        viewModel.getAllPersonalThoughts() // TODO: Possibly jadiin loading animation
    }
    
    private func setupContents(){
        philosopherImageView.image = viewModel.philosopherImage()
        philosopherShortDescription.text = viewModel.philosopherShortDescription()
        philosopherShortDescription.numberOfLines = 0
        ideasTableView.showsVerticalScrollIndicator = false
    }
    
    private func setupConstraints(){
        view.addSubview(philosopherImageView)
        view.addSubview(philosopherShortDescription)
        view.addSubview(ideasTableView)
        
        NSLayoutConstraint.activate([
            philosopherImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            philosopherImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            philosopherImageView.widthAnchor.constraint(equalToConstant: 200),
            philosopherImageView.heightAnchor.constraint(equalToConstant: 200),
            
            philosopherShortDescription.topAnchor.constraint(equalTo: philosopherImageView.bottomAnchor, constant: 20),
            philosopherShortDescription.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            philosopherShortDescription.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
        ])
    }
    
    private func setupTableView () {
        ideasTableView.delegate = self
        ideasTableView.dataSource = self
        NSLayoutConstraint.activate([
            ideasTableView.topAnchor.constraint(equalTo: philosopherShortDescription.bottomAnchor, constant: 20),
            ideasTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            ideasTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            ideasTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])
    }
    
    
}

extension PhilosopherDetailVc : UITableViewDelegate {
    // MARK: Table View delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("section : \(indexPath.section)")
    }
    
}

extension PhilosopherDetailVc : UITableViewDataSource {
    // MARK: Table View Datasource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let itemCount = viewModel.itemCount()
        return itemCount
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.itemCountAtSection(at: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // MARK: Ini itu nanti jadi si cell anaknya
        let cell = tableView.dequeueReusableCell(withIdentifier: "t-cell", for: indexPath) as! ThoughtsCell
        cell.thoughtLabel.text = viewModel.childItemForSection(section: indexPath.section)[indexPath.row].content
        cell.idea = viewModel.itemForIndex(index: indexPath.section).idea
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as! IdeasTableViewHeader
        headerView.delegate = self
        headerView.ideaLabel.text = viewModel.itemForIndex(index: section).idea
        headerView.tag = section
        return headerView
    }
    
    
}

extension PhilosopherDetailVc : PhilosopherDetailViewModelViewDelegate {
    // MARK: Delegate that handles output from view-model
    
    func didFinishFetchingPersonalThoughts() {
        // TODO: Possibly matiin loading animation nanti
        DispatchQueue.main.async {
            self.setupTableView()
        }
    }
    
}

extension PhilosopherDetailVc : ThoughtsCellDelegate {
    
    func didTapEdit(idea : String ,thought: String) {
        let philosopherDataModel = PhilosopherDataBaseModel(name: viewModel.philosopherName())
        let ideaDataModel = IdeasDatabaseModel(idea: idea)
        let thoughtModel = PersonalThoughtDataBaseModel(content: thought)
        viewModel.beginEditingThoughts(philosoperData: philosopherDataModel, ideaData: ideaDataModel, thought: thoughtModel ,from: self)
    }
    
    func didTapDelete(idea : String, thought: String) {
        let philosopherDataModel = PhilosopherDataBaseModel(name: viewModel.philosopherName())
        let ideaDataModel = IdeasDatabaseModel(idea: idea)
        let thoughtModel = PersonalThoughtDataBaseModel(content: thought)
        viewModel.deleteThought(philosoperData: philosopherDataModel, ideaData: ideaDataModel, thought: thoughtModel)
    }
}

extension PhilosopherDetailVc : IdeasHeaderDelegate {
    
    // MARK: Delegate that handles tapped from table view cell
    func toggleSection(_ header: IdeasTableViewHeader, section: Int) {
        viewModel.switchToggle(for: section)
        ideasTableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic) // MARK: Ini langsung expand/collapse
    }
    
    
    func plusButtonTapped(thought: String) {
        // TODO: Present sheet to personal thoughts vc
        let philosopherDataModel = PhilosopherDataBaseModel(name: viewModel.philosopherName())
        let ideaDataModel = IdeasDatabaseModel(idea: thought)
        viewModel.beginAddingThoughts(philosoperData: philosopherDataModel, ideaData: ideaDataModel ,from: self)
    }
}
