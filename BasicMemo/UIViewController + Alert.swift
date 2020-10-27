//
//  UIViewController + Alert.swift
//  BasicMemo
//
//  Created by Fenta on 2020/10/27.
//

import UIKit

extension UIViewController {
    func alert(title: String = "알림", message: String, _ handler: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인",
                                     style: .default) { (_) in
            handler?()
        }
        
        alert.addAction(okAction)
        
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
}
