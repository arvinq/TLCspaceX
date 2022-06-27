//
// Copyright © 2022 arvinq. All rights reserved.
//
	

import UIKit

/**
 Sub label for supplementary labels
 */
class SubHeaderLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(fontSize: CGFloat, fontColor: UIColor = .tertiaryLabel) {
        self.init(frame: .zero)
        font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
        textColor = fontColor
    }
    
    private func configure() {
        adjustsFontSizeToFitWidth   = true
        minimumScaleFactor          = 0.9
        lineBreakMode               = .byTruncatingTail
        isUserInteractionEnabled    = true
        translatesAutoresizingMaskIntoConstraints = false
    }

}
