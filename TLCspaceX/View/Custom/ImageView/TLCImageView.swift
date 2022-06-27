//
// Copyright © 2022 arvinq. All rights reserved.
//
	

import UIKit

class TLCImageView: UIImageView {

    var animateLoadView: (()->())?
    
    var isLoading: Bool = false {
        didSet { self.animateLoadView?() }
    }

    lazy var networkManager: NetworkManager = {
        return NetworkManager()
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        layer.cornerRadius = Space.cornerRadius
        clipsToBounds = true
        contentMode = .scaleAspectFit
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    /**
     * Communicates with NetworkManager to fetch the image resource from the url passed.
     * - Parameters:
     *   - url: URL to download the image resource from.
     */
    func downloadImage(from url: String?) {
        // if there's no url passed, we simply return
        guard let url = url else { return }
        
        self.isLoading = true
        
        networkManager.downloadImage(from: url) { [weak self] image in
            guard let self = self, let image = image else { return }
            
            self.isLoading = false
            DispatchQueue.main.async { self.image = image }
        }
    }

}
