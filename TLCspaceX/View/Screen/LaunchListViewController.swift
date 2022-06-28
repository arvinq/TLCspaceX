//
// Copyright © 2022 arvinq. All rights reserved.
//
	

import UIKit

class LaunchListViewController: UIViewController {

    /// sole section to be used in our diffable data source
    enum Section { case main }
    
    var datasource: UICollectionViewDiffableDataSource<Section, LaunchCellViewModel>!
    
    //MARK: - Property Declaration
    lazy var launchCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.register(LaunchCollectionViewCell.self, forCellWithReuseIdentifier: LaunchCollectionViewCell.reuseId)
        collectionView.delegate = self
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
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        setupView()
        setupConstraint()
        setupViewModel()
        setupDatasource()
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
                self.updateData(using: self.viewModelManager.getUnfilteredLaunches())
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
            
            DispatchQueue.main.async {
                self.updateData(using: self.viewModelManager.getFilteredLaunches())
            }
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

        // resetting our filtered launches when we navigate to filter|sort view
        viewModelManager.setInitialFilteredLaunches()
        filterSortViewController.viewModelManager = viewModelManager
        
        present(tempNavigationController, animated: true)
    }
}

extension LaunchListViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    //MARK: - DataSource and Snapshot Configuration
    
    /// Initialize our data source. We also setup our custom cell to be used in our collection view referenced by the data source
    func setupDatasource() {
        datasource = UICollectionViewDiffableDataSource<Section, LaunchCellViewModel>(collectionView: launchCollectionView, cellProvider: { (collectionView, indexpath, launchCellViewModel) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LaunchCollectionViewCell.reuseId, for: indexpath) as! LaunchCollectionViewCell
            cell.launchViewModel = launchCellViewModel
            return cell
        })
    }
    
    /**
     * Create and apply a diff onto the snapshot using our current datasource and the list passed.
     *
     * - Parameters:
     *   - launchList: list to diff our current launch list to
     */
    func updateData(using launchList: [LaunchCellViewModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, LaunchCellViewModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(launchList)
        datasource.apply(snapshot, animatingDifferences: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.width * 0.9
        let cellHeight = collectionView.frame.height * 0.1
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let launchInfoViewController = LaunchInfoViewController()
        
        // Get our view model in the datasource pointed to by the selected indexPath
        guard let launchCellViewModel = datasource.itemIdentifier(for: indexPath) else { return }
        launchInfoViewController.launchId = launchCellViewModel.id
        
        let tempNavigationController = UINavigationController(rootViewController: launchInfoViewController)
        present(tempNavigationController, animated: true)
    }
}
