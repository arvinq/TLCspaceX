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
    
    lazy var filterSortBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(image: SFSymbol.filterSort, style: .plain, target: self, action: #selector(filterSortPressed))
        return barButtonItem
    }()
    
    lazy var refreshControl: UIRefreshControl = {
       let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshCollection), for: .valueChanged)
        return refreshControl
        
    }()
    
    lazy var viewModelManager: ViewModelManager = {
       return ViewModelManager()
    }()
    
    var isFiltered: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        setupView()
        setupConstraint()
        setupViewModel()
        setupObserver()
        
        // fetch the launches and setup into our collectionView
        viewModelManager.getLaunches()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        title = Title.launchList
        navigationItem.setRightBarButton(filterSortBarButtonItem, animated: true)
        
        launchCollectionView.refreshControl = refreshControl
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
    
    func setupObserver() {
        NotificationCenter.default.addObserver(forName: .TLCApplyFilterAndSort, object: nil, queue: nil) { [weak self] notification in
            guard let self = self else { return }
            
            self.isFiltered = true
            DispatchQueue.main.async { self.launchCollectionView.reloadData() }
        }
    }
    
    @objc
    func refreshCollection() {
        viewModelManager.getLaunches()
        launchCollectionView.refreshControl?.endRefreshing()
    }
    
    /// Show filter and sort view controller
    @objc
    private func filterSortPressed() {
        let filterSortViewController = FilterSortViewController()
        let tempNavigationController = UINavigationController(rootViewController: filterSortViewController)

        filterSortViewController.viewModelManager = viewModelManager
        
        present(tempNavigationController, animated: true)
    }
}

extension LaunchListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let launchViewModels = viewModelManager.getLaunchViewModels(isFiltered: isFiltered)
        return launchViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let launchCell = collectionView.dequeueReusableCell(withReuseIdentifier: LaunchCollectionViewCell.reuseId, for: indexPath) as! LaunchCollectionViewCell
        launchCell.launchViewModel = viewModelManager.getLaunchCellViewModel(on: indexPath.item, isFiltered: isFiltered)
        return launchCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.width * 0.9
        let cellHeight = collectionView.frame.height * 0.05
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let launchInfoViewController = LaunchInfoViewController()
        let launchCellViewModel = viewModelManager.getLaunchCellViewModel(on: indexPath.item, isFiltered: isFiltered)
        launchInfoViewController.launchId = launchCellViewModel.id
        
        let tempNavigationController = UINavigationController(rootViewController: launchInfoViewController)
        present(tempNavigationController, animated: true)
    }
}
