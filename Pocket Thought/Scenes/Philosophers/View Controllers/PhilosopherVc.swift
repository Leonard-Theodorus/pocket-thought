//
//  ViewController.swift
//  Pocket Thought
//
//  Created by Alonica🐦‍⬛🐺 on 04/07/24.
//

import UIKit
import FirebaseAuth

class PhilosopherViewController : UIViewController {
    
    //MARK: -- View Components --
    lazy var gridView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    lazy var loadingView : UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(frame: .zero)
        view.style = .large
        view.translatesAutoresizingMaskIntoConstraints = false
        view.startAnimating()
        return view
    }()
    
    //MARK: -- Dependencies --
    var viewModel : PhilosopherInputDelegate! {
        didSet{
            viewModel.viewDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.start()
        setupLoadingView()
    }
    
    private func setupLoadingView(){
        view.backgroundColor = .white
        view.addSubview(loadingView)
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupGridView(){
        DispatchQueue.main.async {
            self.loadingView.stopAnimating()
            self.loadingView.removeFromSuperview()
        }
        
        gridView.register(PhilosopherViewcell.self, forCellWithReuseIdentifier: "p-cell")
        view.addSubview(gridView)
        NSLayoutConstraint.activate([
            gridView.topAnchor.constraint(equalTo: view.topAnchor),
            gridView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gridView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gridView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    
}

extension PhilosopherViewController : PhilosopherViewModelViewDelegate {
    
    func didFinishLoading(philosophers: [Philosopher]) {
        DispatchQueue.main.async {
            self.setupGridView()
            self.gridView.delegate = self
            self.gridView.dataSource = self
        }
    }
}

extension PhilosopherViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.itemCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = gridView.dequeueReusableCell(withReuseIdentifier: "p-cell", for: indexPath) as! PhilosopherViewcell
        let item = viewModel.itemAt(row: indexPath.row)
        cell.philosopherImageView.image = item.photo
        cell.nameCard.philosopherNameLabel.text = item.name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectItem(index: indexPath.row, from: self)
    }
}

extension PhilosopherViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width : CGFloat = (self.view.frame.width / 2) - 15
        let height : CGFloat = 250
        return .init(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        .init(top: 0, left: 8, bottom: 0, right: 8)
    }
    
}
