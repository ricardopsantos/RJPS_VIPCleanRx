//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
//
import RxSwift
import RJPSLib
import RxCocoa
//
import DevTools
import Extensions
import AppTheme
import AppConstants
import AppResources
import PointFreeFunctions
import Domain

//
// MARK: - Keyboard
//

extension BaseViewControllerMVP {

    var keyboardHeigth: CGFloat {
        if _keyboardIsVisible {
            let autoCorrectBarSize: CGFloat = 44; return _keyboardHeigth - autoCorrectBarSize
        } else {
            return 0
        }
    }

    func setupKeyboard() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(self.keyboardWillShowNotification(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(self.keyboardWillHideNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(self.keyboardDidShowNotification(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(self.keyboardDidHideNotification(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    @objc private func keyboardWillHideNotification(_ notification: Notification) { }
    @objc private func keyboardDidShowNotification(_ notification: Notification) { _keyboardIsVisible=true; self.keyboardDidShow() }
    @objc private func keyboardDidHideNotification(_ notification: Notification) { _keyboardIsVisible=false; _keyboardHeigth=0; self.keyboardDidHide() }
    @objc private func keyboardWillShowNotification(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
                UIView.animate(withDuration: 0.3, animations: {
                    self._keyboardHeigth = contentInsets.bottom
                })
            }
        }
    }
}
