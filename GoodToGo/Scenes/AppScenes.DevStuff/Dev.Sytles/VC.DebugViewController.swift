//
//  VC.StylesViewController.swift
//  GoodToGo
//
//  Created by Ricardo Santos on 14/05/2020.
//  Copyright (c) 2020 Ricardo P Santos. All rights reserved.
//
import Foundation
import UIKit
//
import RxCocoa
import RxSwift
import TinyConstraints
//
import AppConstants
import AppTheme
import Designables
import DevTools
import Domain
import Extensions
import PointFreeFunctions
import AppResources
import UIBase

extension VC {

    class DebugViewController: BaseGenericViewControllerVIP<V.DebugView> {
        private var interactor: DebugBusinessLogicProtocol?
        var router: (DebugRoutingLogicProtocol &
            DebugDataPassingProtocol &
            DebugRoutingLogicProtocol)?

        let bottomBar = BottomBar()

        private lazy var topGenericView: TopBar = {
            let some = TopBar()
            some.injectOn(viewController: self, usingSafeArea: false)
            /*some.addDismissButton()
            some.rxSignal_viewTapped
                .asObservable().subscribe(onNext: { (_) in
                    DevTools.makeToast("Tap!")
                }).disposed(by: disposeBag)*/
            return some
        }()

        //
        // MARK: View lifecycle
        //

        override func loadView() {
            super.loadView()
            view.accessibilityIdentifier = self.genericAccessibilityIdentifier
            self.title = "DevScreen"
        }

        override func viewDidLoad() {
            super.viewDidLoad()
        }

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            if firstAppearance {
                //bottomBar.injectOn(viewController: self, usingSafeArea: false)
                topGenericView.lazyLoad()
                interactor?.requestScreenInitialState()
            }
        }

        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)

            DevTools.Log.message("message")
            DevTools.Log.warning("warning")
            DevTools.Log.error("error")

        }

        //
        // MARK: Dark Mode
        //

        public override func setupColorsAndStyles() {
            //super.setupColorsAndStyles()
            // Setup UI on dark mode (if needed)
        }

        //
        // MARK: Mandatory methods
        //

        override func setup() {
            // This function is called automatically by super BaseGenericView
            let viewController = self
            let interactor = I.DebugInteractor()
            let presenter  = P.DebugPresenter()
            let router     = R.DebugRouter()
            viewController.interactor = interactor
            viewController.router = router
            interactor.presenter  = presenter
            presenter.viewController = viewController
            router.viewController = viewController
            router.dsStyles = interactor
        }

        // This function is called automatically by super BaseGenericView
        override func setupViewIfNeed() {
            // Use it to configure stuff on the genericView, depending on the value external/public variables
            // that are set after we instantiate the view controller, but before if has been presented
        }

        // This function is called automatically by super BaseGenericView
        override func setupViewUIRx() {

        }

        // This function is called automatically by super BaseGenericView
        override func setupNavigationUIRx() {
            // Add options to navigation bar
        }
    }
}

// MARK: Public Misc Stuff

extension VC.DebugViewController {

}

// MARK: Private Misc Stuff

extension VC.DebugViewController {

}

// MARK: DisplayLogicProtocolProtocol

extension VC.DebugViewController: DebugDisplayLogicProtocol {

    func displaySomeStuff(viewModel: VM.Debug.SomeStuff.ViewModel) {
        // Setting up the view, option 1 : passing the view model
    }

    func displayScreenInitialState(viewModel: VM.Debug.ScreenInitialState.ViewModel) {
        title = viewModel.title
    }
}
