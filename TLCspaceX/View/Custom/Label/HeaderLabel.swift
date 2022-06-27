//
// Copyright © 2022 arvinq. All rights reserved.
//
	

import UIKit

/**
 Main label used for large, main texts
 */
class HeaderLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(fontSize: CGFloat, text: String = "", textColor: UIColor = .label) {
        self.init(frame: .zero)
        self.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
        self.text = text
        self.textColor = textColor
    }
    
    private func setup() {
        adjustsFontSizeToFitWidth   = true
        minimumScaleFactor          = 0.9
        lineBreakMode               = .byTruncatingTail
        isUserInteractionEnabled    = true
        translatesAutoresizingMaskIntoConstraints = false
    }
}
