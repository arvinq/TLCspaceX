//
// Copyright © 2022 arvinq. All rights reserved.
//
	

import UIKit

class LaunchInfoViewController: UIViewController {
    
    var launchId: String?
    var launchInfoViewModel: LaunchInfoViewModel?
    
    lazy var viewModelManager: ViewModelManager = {
       return ViewModelManager()
    }()
    
    // Containers
    lazy var scrollView: UIScrollView = { return UIScrollView() }()
    lazy var contentView: UIView = { return UIView() }()
    
    lazy var launchNameLabel: DetailLabel = {
        let label = DetailLabel(fontSize: 16.0, fontColor: .label)
        return label
    }()
    
    lazy var launchDetailsCaption: DetailLabel = {
        let label = DetailLabel(fontSize: 14.0, fontColor: .label)
        label.text = Caption.detailCaption
        return label
    }()
    
    lazy var launchDetailsLabel: DetailLabel = {
        let label = DetailLabel(fontSize: 12.0, fontColor: .label)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var launchDateCaption: DetailLabel = {
        let label = DetailLabel(fontSize: 14.0, fontColor: .label)
        label.text = Caption.dateCaption
        return label
    }()
    
    lazy var launchDateLabel: DetailLabel = {
        let label = DetailLabel(fontSize: 12.0, fontColor: .label)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var launchStatusCaption: DetailLabel = {
        let label = DetailLabel(fontSize: 14.0, fontColor: .label)
        label.text = Caption.statusCaption
        return label
    }()
    
    lazy var launchStatusLabel: DetailLabel = {
        let label = DetailLabel(fontSize: 12.0, fontColor: .label)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var chevronImageView: UIImageView = {
        let imageView = UIImageView(image: SFSymbol.chevron?.withTintColor(.label, renderingMode: .alwaysOriginal))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var launchPatchsCaption: DetailLabel = {
        let label = DetailLabel(fontSize: 14.0, fontColor: .label)
        label.text = Caption.patchCaption
        return label
    }()
    
    lazy var launchThumbnailImageView: TLCImageView = {
        return TLCImageView(frame: .zero)
    }()
    
    lazy var closeBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(image: SFSymbol.close, style: .done, target: self, action: #selector(closePressed))
        return barButtonItem
    }()
    
    lazy var firstSeparatorView: TLCSeparatorView = { return TLCSeparatorView() }()
    lazy var secondSeparatorView: TLCSeparatorView = { return TLCSeparatorView() }()
    lazy var thirdSeparatorView: TLCSeparatorView = { return TLCSeparatorView() }()
    lazy var fourthSeparatorView: TLCSeparatorView = { return TLCSeparatorView() }()
    lazy var fifthSeparatorView: TLCSeparatorView = { return TLCSeparatorView() }()
    lazy var sixthSeparatorView: TLCSeparatorView = { return TLCSeparatorView() }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    lazy var rocketButton: UIButton = {
        let button = UIButton()
        button.setTitle(Title.getRocket, for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: .medium)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(rocketButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        title = Title.launchInfo
        view.backgroundColor = .systemBackground
        navigationItem.setLeftBarButton(closeBarButtonItem, animated: true)
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(launchNameLabel)
        
        contentView.addSubview(launchDetailsCaption)
        contentView.addSubview(launchDetailsLabel)
        
        contentView.addSubview(launchDateCaption)
        contentView.addSubview(launchDateLabel)
        
        contentView.addSubview(launchStatusCaption)
        contentView.addSubview(launchStatusLabel)
        
        contentView.addSubview(activityIndicator)
        contentView.addSubview(rocketButton)
        contentView.addSubview(chevronImageView)
        
        contentView.addSubview(launchPatchsCaption)
        contentView.addSubview(launchThumbnailImageView)
        
        // separators
        contentView.addSubview(firstSeparatorView)
        contentView.addSubview(secondSeparatorView)
        contentView.addSubview(thirdSeparatorView)
        contentView.addSubview(fourthSeparatorView)
        contentView.addSubview(fifthSeparatorView)
        contentView.addSubview(sixthSeparatorView)
    }
    
    private func setupConstraints() {
        scrollView.pinToEdges(of: view)
        contentView.pinToEdges(of: scrollView)
        
        NSLayoutConstraint.activate([
            // we need to set contentView's width and height in addition to pinning it
            // to scrollView's edges so that we can make it movable inside scrollView.
            // This will greatly take into effect should our content becomes large enough.
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 700),
            
            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            launchNameLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: Space.margin),
            launchNameLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
            launchNameLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            
            firstSeparatorView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            firstSeparatorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            firstSeparatorView.heightAnchor.constraint(equalToConstant: Size.separatorHeight),
            firstSeparatorView.topAnchor.constraint(equalTo: launchNameLabel.bottomAnchor, constant: Space.adjacent),
            
            launchDetailsCaption.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: Space.margin),
            launchDetailsCaption.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -Space.margin),
            launchDetailsCaption.topAnchor.constraint(equalTo: firstSeparatorView.bottomAnchor, constant: Space.adjacent),
            
            launchDetailsLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: Space.margin),
            launchDetailsLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -Space.margin),
            launchDetailsLabel.topAnchor.constraint(equalTo: launchDetailsCaption.bottomAnchor),
            
            secondSeparatorView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            secondSeparatorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            secondSeparatorView.heightAnchor.constraint(equalToConstant: Size.separatorHeight),
            secondSeparatorView.topAnchor.constraint(equalTo: launchDetailsLabel.bottomAnchor, constant: Space.adjacent),
            
            launchDateCaption.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: Space.margin),
            launchDateCaption.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -Space.margin),
            launchDateCaption.topAnchor.constraint(equalTo: secondSeparatorView.bottomAnchor, constant: Space.adjacent),
            
            launchDateLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: Space.margin),
            launchDateLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -Space.margin),
            launchDateLabel.topAnchor.constraint(equalTo: launchDateCaption.bottomAnchor),
            
            thirdSeparatorView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            thirdSeparatorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            thirdSeparatorView.heightAnchor.constraint(equalToConstant: Size.separatorHeight),
            thirdSeparatorView.topAnchor.constraint(equalTo: launchDateLabel.bottomAnchor, constant: Space.adjacent),
            
            launchStatusCaption.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: Space.margin),
            launchStatusCaption.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -Space.margin),
            launchStatusCaption.topAnchor.constraint(equalTo: thirdSeparatorView.bottomAnchor, constant: Space.adjacent),
            
            launchStatusLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: Space.margin),
            launchStatusLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -Space.margin),
            launchStatusLabel.topAnchor.constraint(equalTo: launchStatusCaption.bottomAnchor),
            
            fourthSeparatorView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            fourthSeparatorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            fourthSeparatorView.heightAnchor.constraint(equalToConstant: Size.separatorHeight),
            fourthSeparatorView.topAnchor.constraint(equalTo: launchStatusLabel.bottomAnchor, constant: Space.adjacent),
            
            rocketButton.topAnchor.constraint(equalTo: fourthSeparatorView.bottomAnchor, constant: Space.adjacent),
            rocketButton.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: Space.margin),
            rocketButton.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
            
            chevronImageView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -Space.margin),
            chevronImageView.centerYAnchor.constraint(equalTo: rocketButton.centerYAnchor),
            
            fifthSeparatorView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            fifthSeparatorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            fifthSeparatorView.heightAnchor.constraint(equalToConstant: Size.separatorHeight),
            fifthSeparatorView.topAnchor.constraint(equalTo: rocketButton.bottomAnchor, constant: Space.adjacent),

            launchPatchsCaption.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: Space.margin),
            launchPatchsCaption.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -Space.margin),
            launchPatchsCaption.topAnchor.constraint(equalTo: fifthSeparatorView.bottomAnchor, constant: Space.adjacent),
            
            launchThumbnailImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            launchThumbnailImageView.topAnchor.constraint(equalTo: launchPatchsCaption.bottomAnchor, constant: Space.adjacent),
            launchThumbnailImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.35),
            
            sixthSeparatorView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            sixthSeparatorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            sixthSeparatorView.heightAnchor.constraint(equalToConstant: Size.separatorHeight),
            sixthSeparatorView.topAnchor.constraint(equalTo: launchThumbnailImageView.bottomAnchor, constant: Space.adjacent),
        ])
    }
    

    private func setupViewModel() {
        viewModelManager.bindLaunchInformation = { [weak self] launchInfoViewModel in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.launchInfoViewModel = launchInfoViewModel
                self.launchThumbnailImageView.downloadImage(from: launchInfoViewModel?.smallPatch)
                self.launchNameLabel.text = launchInfoViewModel?.name
                self.launchDetailsLabel.text = launchInfoViewModel?.getLaunchDetails()
                self.launchDateLabel.text = launchInfoViewModel?.printableLaunchDate
                self.launchStatusLabel.text = launchInfoViewModel?.getLaunchStatus()
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
                        self.view.alpha = Alpha.strongFade
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
        guard let launchId = launchId else { return }
        viewModelManager.getOneLaunch(for: launchId)
    }
    
    @objc
    private func rocketButtonTapped() {
        let rocketInfoViewController = RocketInfoViewController()
        rocketInfoViewController.rocketId = launchInfoViewModel?.rocketId
        
        let tempNavigationController = UINavigationController(rootViewController: rocketInfoViewController)
        present(tempNavigationController, animated: true)
    }
    
    @objc
    private func closePressed() {
        dismiss(animated: true)
    }
    
}
