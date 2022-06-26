//
// Copyright © 2022 arvinq. All rights reserved.
//
	

import UIKit

class LaunchCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Property Declaration
    
    // reuse identifier
    static let reuseId = "LaunchCollectionViewCell"
    
    lazy var launchLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var separatorView: TLCSeparatorView = {
        let view = TLCSeparatorView()
        return view
    }()
    
    var launchViewModel: LaunchViewModel? {
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
        addSubview(launchLabel)
        addSubview(separatorView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            launchLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            launchLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            launchLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            separatorView.heightAnchor.constraint(equalToConstant: Size.separatorHeight),
            separatorView.widthAnchor.constraint(equalTo: widthAnchor),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    private func bindValues() {
        self.launchLabel.text = launchViewModel?.name
    }
}
