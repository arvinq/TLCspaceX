//
// Copyright © 2022 arvinq. All rights reserved.
//
	

import UIKit

class LaunchInfoViewController: UIViewController {
    
    var launchCellViewModel: LaunchCellViewModel?
    lazy var viewModelManager: ViewModelManager = {
       return ViewModelManager()
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        setupView()
        setupConstraints()
        setupViewModel()
        
        fetchLaunchInfo()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(activityIndicator)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    

    private func setupViewModel() {
        viewModelManager.bindLaunchInformation = { [weak self] launchInfoViewModel in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.title = launchInfoViewModel?.name
            }
        }
        
        // presenting an alert
        viewModelManager.presentAlert = { [weak self] in
            guard let self = self else { return }
            let message = self.viewModelManager.alertMessage ?? ""
            
            DispatchQueue.main.async {
                self.presentAlert(withTitle: Title.launchAlert, andMessage: message, completion: nil)
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
                        self.view.alpha = Alpha.weakFade
                    }
                } else {
                    self.activityIndicator.stopAnimating()
                    UIView.animate(withDuration: Animation.duration) {
                        self.view.alpha = Alpha.solid
                    }
                }
            }
        }

    }
    
    private func fetchLaunchInfo() {
        guard let launchCellViewModel = launchCellViewModel else {
            return
        }

        viewModelManager.getOneLaunch(for: launchCellViewModel.id)
    }
}
