//
//  R.StylesRouter.swift
//  GoodToGo
//
//  Created by Ricardo Santos on 14/05/2020.
//  Copyright (c) 2020 Ricardo P Santos. All rights reserved.
//

import UIKit
import Foundation
//
import RxCocoa
import RxSwift
//
import AppConstants
import AppTheme
import Designables
import DevTools
import Domain
import Extensions
import PointFreeFunctions
import UIBase

extension R {
    class StylesRouter: StylesDataPassingProtocol {
        weak var viewController: VC.StylesViewController?

        // DataPassingProtocol Protocol vars...
        var dsStyles: StylesDataStoreProtocol? { didSet { AppLogger.log("DataStore changed") } }
     }
}

// MARK: RoutingLogicProtocol

extension R.StylesRouter: StylesRoutingLogicProtocol {
    func dismissMe() {
        viewController?.dismissMe()
    }

    func routeToTemplateWithDataStore() {
        func passDataToSomewhere(source: StylesDataStoreProtocol, destination: inout StylesDataStoreProtocol) {
            destination.dsSomeKindOfModelA = source.dsSomeKindOfModelA
            destination.dsSomeKindOfModelB = source.dsSomeKindOfModelB
        }
        let destinationVC = VC.StylesViewController()
        if var destinationDS = destinationVC.router?.dsStyles {
            passDataToSomewhere(source: dsStyles!, destination: &destinationDS)
        }
        viewController?.navigationController?.present(destinationVC, animated: true, completion: nil)
    }

    func routeToTemplateWithParentDataStore() {
        routeToTemplateWithDataStore()
    }

}