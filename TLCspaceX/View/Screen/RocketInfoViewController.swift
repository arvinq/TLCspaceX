//
// Copyright © 2022 arvinq. All rights reserved.
//
	

import UIKit

class RocketInfoViewController: UIViewController {

    var rocketId: String?
    var rocketInfoViewModel: RocketInfoViewModel?
    
    lazy var viewModelManager: ViewModelManager = {
       return ViewModelManager()
    }()
    
    // Containers
    lazy var scrollView: UIScrollView = { return UIScrollView() }()
    lazy var contentView: UIView = { return UIView() }()
    
    lazy var rocketImageView: TLCImageView = {
        return TLCImageView(frame: .zero)
    }()
    
    lazy var rocketNameLabel: DetailLabel = {
        let label = DetailLabel(fontSize: 18.0, fontColor: .label)
        return label
    }()
    
    lazy var companyNameLabel: DetailLabel = {
        let label = DetailLabel(fontSize: 12.0, fontColor: .label)
        return label
    }()
    
    lazy var rocketDescriptionCaption: DetailLabel = {
        let label = DetailLabel(fontSize: 14.0, fontColor: .label)
        label.text = Caption.descriptionCaption
        return label
    }()
    
    lazy var rocketDescriptionLabel: DetailLabel = {
        let label = DetailLabel(fontSize: 12.0, fontColor: .label)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var rocketBoosterDetailsCaption: DetailLabel = {
        let label = DetailLabel(fontSize: 12.0, fontColor: .label)
        label.text = Caption.boosterCaption
        return label
    }()
    
    lazy var rocketBoosterDetailsLabel: DetailLabel = {
        let label = DetailLabel(fontSize: 14.0, fontColor: .label)
        return label
    }()
    
    lazy var rocketSuccessRateDetailsCaption: DetailLabel = {
        let label = DetailLabel(fontSize: 12.0, fontColor: .label)
        label.text = Caption.successRateCaption
        return label
    }()
    
    lazy var rocketSuccessRateDetailsLabel: DetailLabel = {
        let label = DetailLabel(fontSize: 14.0, fontColor: .label)
        return label
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    lazy var rocketWikiButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.label, for: .normal)
        button.setTitle(Title.getRocketWiki, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: .medium)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(rocketWikiButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var chevronImageView: UIImageView = {
        let imageView = UIImageView(image: SFSymbol.chevron?.withTintColor(.label, renderingMode: .alwaysOriginal))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var closeBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(image: SFSymbol.close, style: .done, target: self, action: #selector(closePressed))
        return barButtonItem
    }()
    
    lazy var firstSeparatorView: TLCSeparatorView = { return TLCSeparatorView() }()
    lazy var secondSeparatorView: TLCSeparatorView = { return TLCSeparatorView() }()
    lazy var thirdSeparatorView: TLCSeparatorView = { return TLCSeparatorView() }()
    lazy var fourthSeparatorView: TLCSeparatorView = { return TLCSeparatorView() }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        setupView()
        setupConstraints()
        setupViewModel()
        
        fetchRocketInfo()
    }
    
    private func setupView() {
        title = Title.rocketInfo
        view.backgroundColor = .systemBackground
        navigationItem.setLeftBarButton(closeBarButtonItem, animated: true)
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(rocketNameLabel)
        contentView.addSubview(rocketImageView)
        contentView.addSubview(companyNameLabel)
        contentView.addSubview(activityIndicator)
        
        contentView.addSubview(rocketDescriptionCaption)
        contentView.addSubview(rocketDescriptionLabel)
        
        contentView.addSubview(rocketBoosterDetailsCaption)
        contentView.addSubview(rocketBoosterDetailsLabel)
        contentView.addSubview(rocketSuccessRateDetailsCaption)
        contentView.addSubview(rocketSuccessRateDetailsLabel)
        
        contentView.addSubview(rocketWikiButton)
        contentView.addSubview(chevronImageView)
        
        // separators
        contentView.addSubview(firstSeparatorView)
        contentView.addSubview(secondSeparatorView)
        contentView.addSubview(thirdSeparatorView)
        contentView.addSubview(fourthSeparatorView)
    }
    
    private func setupConstraints() {
        scrollView.pinToEdges(of: view)
        contentView.pinToEdges(of: scrollView)
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 700),
            
            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            rocketImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            rocketImageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            rocketImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.35),
            
            rocketNameLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: Space.margin),
            rocketNameLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
            rocketNameLabel.topAnchor.constraint(equalTo: rocketImageView.bottomAnchor, constant: Space.adjacent),
            
            companyNameLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: Space.margin),
            companyNameLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
            companyNameLabel.topAnchor.constraint(equalTo: rocketNameLabel.bottomAnchor, constant: Space.sameGroupAdjacent),
            
            firstSeparatorView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            firstSeparatorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            firstSeparatorView.heightAnchor.constraint(equalToConstant: Size.separatorHeight),
            firstSeparatorView.topAnchor.constraint(equalTo: companyNameLabel.bottomAnchor, constant: Space.adjacent),
            
            rocketDescriptionCaption.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: Space.margin),
            rocketDescriptionCaption.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -Space.margin),
            rocketDescriptionCaption.topAnchor.constraint(equalTo: firstSeparatorView.bottomAnchor, constant: Space.adjacent),
            
            rocketDescriptionLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: Space.margin),
            rocketDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -Space.margin),
            rocketDescriptionLabel.topAnchor.constraint(equalTo: rocketDescriptionCaption.bottomAnchor),
            
            secondSeparatorView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            secondSeparatorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            secondSeparatorView.heightAnchor.constraint(equalToConstant: Size.separatorHeight),
            secondSeparatorView.topAnchor.constraint(equalTo: rocketDescriptionLabel.bottomAnchor, constant: Space.adjacent),
            
            rocketBoosterDetailsCaption.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: Space.margin),
            rocketBoosterDetailsCaption.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -Space.margin),
            rocketBoosterDetailsCaption.topAnchor.constraint(equalTo: secondSeparatorView.bottomAnchor, constant: Space.adjacent),
            
            rocketBoosterDetailsLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: Space.margin),
            rocketBoosterDetailsLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -Space.margin),
            rocketBoosterDetailsLabel.topAnchor.constraint(equalTo: rocketBoosterDetailsCaption.bottomAnchor),
            
            rocketSuccessRateDetailsCaption.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: Space.margin),
            rocketSuccessRateDetailsCaption.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -Space.margin),
            rocketSuccessRateDetailsCaption.topAnchor.constraint(equalTo: rocketBoosterDetailsLabel.bottomAnchor, constant: Space.adjacent),
            
            rocketSuccessRateDetailsLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: Space.margin),
            rocketSuccessRateDetailsLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -Space.margin),
            rocketSuccessRateDetailsLabel.topAnchor.constraint(equalTo: rocketSuccessRateDetailsCaption.bottomAnchor),
            
            thirdSeparatorView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            thirdSeparatorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            thirdSeparatorView.heightAnchor.constraint(equalToConstant: Size.separatorHeight),
            thirdSeparatorView.topAnchor.constraint(equalTo: rocketSuccessRateDetailsLabel.bottomAnchor, constant: Space.adjacent),
            
            rocketWikiButton.topAnchor.constraint(equalTo: thirdSeparatorView.bottomAnchor, constant: Space.adjacent),
            rocketWikiButton.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: Space.margin),
            rocketWikiButton.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
            
            chevronImageView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -Space.margin),
            chevronImageView.centerYAnchor.constraint(equalTo: rocketWikiButton.centerYAnchor),
            
            fourthSeparatorView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            fourthSeparatorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            fourthSeparatorView.heightAnchor.constraint(equalToConstant: Size.separatorHeight),
            fourthSeparatorView.topAnchor.constraint(equalTo: rocketWikiButton.bottomAnchor, constant: Space.adjacent),
        ])
    }
    
    private func setupViewModel() {
        viewModelManager.bindRocketInformation = { [weak self] rocketInfoViewModel in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.rocketInfoViewModel = rocketInfoViewModel
                self.rocketNameLabel.text = rocketInfoViewModel?.name
                self.rocketImageView.downloadImage(from: rocketInfoViewModel?.rocketImageURL)
                self.companyNameLabel.text = rocketInfoViewModel?.company
                self.rocketDescriptionLabel.text = rocketInfoViewModel?.description
                self.rocketBoosterDetailsLabel.text = rocketInfoViewModel?.booster
                self.rocketSuccessRateDetailsLabel.text = rocketInfoViewModel?.successRatePct
            }
        }
        
        // presenting an alert
        viewModelManager.presentAlert = { [weak self] in
            guard let self = self else { return }
            let message = self.viewModelManager.alertMessage ?? ""
            
            DispatchQueue.main.async {
                self.presentAlert(withTitle: Title.rocketAlert, andMessage: message, completion: nil)
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
    
    private func fetchRocketInfo() {
        guard let rocketId = rocketId else { return }
        viewModelManager.getOneRocket(for: rocketId)

    }
    
    @objc
    private func rocketWikiButtonTapped() {
        guard let rocketInfoViewModel = rocketInfoViewModel,
              let wikipediaURL = URL(string: rocketInfoViewModel.wikipedia) else {
            presentAlert(withTitle: Title.getRocketWiki, andMessage: TLCError.wikiError.rawValue, completion: nil)
            return
        }
        
        showSafariWebView(on: wikipediaURL)
    }
    
    @objc
    private func closePressed() {
        dismiss(animated: true)
    }
}
