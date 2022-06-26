//
// Copyright © 2022 arvinq. All rights reserved.
//
	

import UIKit

class LaunchListViewController: UIViewController {

    //MARK: - Property Declaration
    
    lazy var launchCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.register(LaunchCollectionViewCell.self, forCellWithReuseIdentifier: LaunchCollectionViewCell.reuseId)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    lazy var viewModelManager: ViewModelManager = {
       return ViewModelManager()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        setupView()
        setupConstraint()
        setupViewModel()
        
        // fetch the launches and setup into our collectionView
        viewModelManager.getLaunches()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        title = Title.launchList
        
        view.addSubview(activityIndicator)
        view.addSubview(launchCollectionView)
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            launchCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            launchCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            launchCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            launchCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    /// Sets up the bindings that controls this view controller's views and will get triggered upon viewModel's property assignment
    private func setupViewModel() {
        // presenting an alert
        viewModelManager.presentAlert = { [weak self] in
            guard let self = self else { return }
            let message = self.viewModelManager.alertMessage ?? ""
            
            DispatchQueue.main.async {
                self.presentAlert(withTitle: Title.launchAlert, andMessage: message, completion: nil)
            }
        }
        
        // reloading our collectionView
        viewModelManager.reloadCollection = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.launchCollectionView.reloadData()
            }
        }
        
        // animating our activity indicator
        viewModelManager.animateLoadView = { [weak self] in
            guard let self = self else { return }
            let isLoading = self.viewModelManager.isLoading
            
            DispatchQueue.main.async {
                if isLoading {
                    self.activityIndicator.startAnimating()
                    UIView.animate(withDuration: Animation.duration) {
                        self.launchCollectionView.alpha = Alpha.weakFade
                    }
                } else {
                    self.activityIndicator.stopAnimating()
                    UIView.animate(withDuration: Animation.duration) {
                        self.launchCollectionView.alpha = Alpha.solid
                    }
                }
            }
        }

    }
}

extension LaunchListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModelManager.launchCellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let launchCell = collectionView.dequeueReusableCell(withReuseIdentifier: LaunchCollectionViewCell.reuseId, for: indexPath) as! LaunchCollectionViewCell
        launchCell.launchViewModel = viewModelManager.getLaunchCellViewModel(on: indexPath.item)
        return launchCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.width * 0.9
        let cellHeight = collectionView.frame.height * 0.05
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let launchInfoViewController = LaunchInfoViewController()
        launchInfoViewController.launchCellViewModel = viewModelManager.getLaunchCellViewModel(on: indexPath.item)
        
        let tempNavigationController = UINavigationController(rootViewController: launchInfoViewController)
        present(tempNavigationController, animated: true)
    }
}
