//
// Copyright © 2022 arvinq. All rights reserved.
//
	

import UIKit

class LaunchCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Property Declaration
    
    // reuse identifier
    static let reuseId = "LaunchCollectionViewCell"
    
    lazy var launchLabel: DetailLabel = {
        return DetailLabel(fontSize: 14.0, fontColor: .label)
    }()
    
    lazy var launchStatusLabel: DetailLabel = {
        return DetailLabel(fontSize: 10, fontColor: .label)
    }()
    
    lazy var launchDateLabel: DetailLabel = {
        return DetailLabel(fontSize: 10, fontColor: .label)
    }()
    
    lazy var cellDetailStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var patchImageView: TLCImageView = {
        let imageView = TLCImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var separatorView: TLCSeparatorView = {
        let view = TLCSeparatorView()
        return view
    }()
    
    var launchViewModel: LaunchCellViewModel? {
        didSet { bindValues() }
    }
    
    //MARK: - Initial Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        setupView()
        setupConstraints()
    }
    
    private func setupView() {
        addSubview(patchImageView)
        addSubview(cellDetailStackView)
        addSubview(separatorView)
        
        cellDetailStackView.addArrangedSubview(launchLabel)
        cellDetailStackView.addArrangedSubview(launchStatusLabel)
        cellDetailStackView.addArrangedSubview(launchDateLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            patchImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            patchImageView.topAnchor.constraint(equalTo: topAnchor),
            patchImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Space.padding),
            patchImageView.widthAnchor.constraint(equalToConstant: 80),
            
            cellDetailStackView.leadingAnchor.constraint(equalTo: patchImageView.trailingAnchor, constant: Space.adjacent),
            cellDetailStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cellDetailStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            separatorView.heightAnchor.constraint(equalToConstant: Size.separatorHeight),
            separatorView.widthAnchor.constraint(equalTo: widthAnchor),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    private func bindValues() {
        self.patchImageView.downloadImage(from: launchViewModel?.smallPatch)
        self.launchLabel.text = launchViewModel?.name
        self.launchStatusLabel.text = launchViewModel?.getLaunchStatus()
        self.launchDateLabel.text = launchViewModel?.getLaunchDate()
        
    }
}
