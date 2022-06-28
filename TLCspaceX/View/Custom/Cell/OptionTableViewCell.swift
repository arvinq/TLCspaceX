//
// Copyright © 2022 arvinq. All rights reserved.
//
	

import UIKit

class OptionTableViewCell: UITableViewCell {
    
    // reuse identifier
    static let reuseId = "OptionTableViewCell"
    
    lazy var optionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
        setupConstraints()
    }
    
    private func setupView() {
        addSubview(optionLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            optionLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            optionLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
}
