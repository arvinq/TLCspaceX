//
// Copyright © 2022 arvinq. All rights reserved.
//
	

import UIKit
import SafariServices

extension UIViewController {
    
    /**
     * Show alert using the passed title and message
     *
     * - Parameters:
     *    - alertTitle: Title of the alert
     *    - message: Information showing the reason for the alert
     *    - completion: closure that is called to do some action when confirming on the alert
     *
     */
    func presentAlert(withTitle alertTitle: String, andMessage message: String, completion: (()->())?) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
            
            var cancelTitle: String = AlertButton.okay
            
            if let completion = completion {
                let okAction = UIAlertAction(title: AlertButton.okay, style: .default) { action in
                    completion()
                }
                
                cancelTitle = AlertButton.cancel
                alertController.addAction(okAction)
            }
            
            let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel)
            alertController.addAction(cancelAction)
    
            self.present(alertController, animated: true)
        }
    }
    
    func showSafariWebView(on url: URL) {
        let safariWebView = SFSafariViewController(url: url)
        safariWebView.preferredControlTintColor = .systemGray
        present(safariWebView, animated: true)
    }
}

