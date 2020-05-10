//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
//
import AppConstants
import Domain

extension AppManagers {
    
    struct Environments {
        private static var _current: AppMode = .dev
        static var current: AppMode { return _current }
        
        private static func set_dev() { _current = .dev; AppLogger.log("Environment set \(String(describing: _current))".uppercased()) }
        private static func set_qa() { _current = .qa;  AppLogger.log("Environment set \(String(describing: _current))".uppercased()) }
        private static func set_prod() { _current = .prod; AppLogger.log("Environment set \(String(describing: _current))".uppercased()) }
        
        static func isDev() -> Bool { return current == .dev }
        static func isQA() -> Bool { return current == .qa }
        static func isProd() -> Bool { return current == .prod }
        
        static func setup() {
            
            func appMode() -> String? {
                return (Bundle.main.infoDictionary?["BuildConfig_AppMode"] as? String)?.replacingOccurrences(of: "\\", with: "")
            }
            
            let block_recover = {
                AppLogger.log(appCode: .notPredicted)
                set_dev()
            }
            
            if let mode = appMode() {
                switch mode {
                case "Debug.Dev"  : set_dev()
                case "Debug.QA"   : set_qa()
                case "Debug.Prod" : set_prod()
                case "Release"    : set_prod()
                default           :
                    block_recover()
                }
            } else {
                block_recover()
            }
        }
    }
}