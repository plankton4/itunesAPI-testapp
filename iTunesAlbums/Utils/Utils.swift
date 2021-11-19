//
//  Utils.swift
//  iTunesAlbums
//
//  Created by Dmitry Iv on 19.11.2021.
//

import UIKit

struct Utils {

    static func showAlert(title: String? = nil, message: String? = nil, firstButtonText: String? = "👍") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        var rootViewController = (UIApplication.shared.windows.first { $0.isKeyWindow })?.rootViewController
        if let navigationController = rootViewController as? UINavigationController {
            rootViewController = navigationController.viewControllers.first
        }
        if let tabBarController = rootViewController as? UITabBarController {
            rootViewController = tabBarController.selectedViewController
        }
        alertController.addAction(UIAlertAction(title: firstButtonText, style: .default))
        rootViewController?.present(alertController, animated: true, completion: nil)
    }
}
