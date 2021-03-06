//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

//swiftlint:disable rule_UIColor_1 rule_UIFont_1

import UIKit
import Foundation
//
import RJSLibUFBase
import RJSLibUFStorage
import RJSLibUFNetworking
import RJSLibUFAppThemes
//
import BaseConstants
import AppTheme
import AppResources
import BaseUI
import DevTools
import Designables

//
// MARK: - RJPSLib Shortcuts
//
// https://github.com/ricardopsantos/RJPSLib
// Turning the RJPSLib alias into something more readable and related to this app it self
//

typealias AppInfo                = RJS_AppInfo         // Utilities for apps and device info. Things like `isSimulator`, `hasNotch`, etc
typealias AppUtils               = RJS_Utils           // Utilities like `onDebug`, `onRelease`, `executeOnce`, etc
typealias AppUserDefaults        = RJS_UserDefaults    // NSUserDefaults utilities (save, delete, get, exits, ...)
typealias WebAPIRequestProtocol  = RJS_SimpleNetworkClientRequestProtocol

public typealias CacheStrategy = RJS_CacheStrategy
