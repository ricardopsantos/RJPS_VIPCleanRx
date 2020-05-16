//
//  VC.CarTrackLoginViewController.swift
//  GoodToGo
//
//  Created by Ricardo Santos on 12/05/2020.
//  Copyright (c) 2020 Ricardo P Santos. All rights reserved.
//
import Foundation
import UIKit
//
import RxCocoa
import RxSwift
import TinyConstraints
import Material
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

    class CarTrackLoginViewController: BaseGenericViewControllerVIP<V.CarTrackLoginView> {
        private var interactor: CarTrackLoginBusinessLogicProtocol?
        var router: (CarTrackLoginRoutingLogicProtocol &
            CarTrackLoginDataPassingProtocol &
            CarTrackLoginRoutingLogicProtocol)?

        //
        // MARK: View lifecycle
        //

        // Order in View life-cycle : 2
        override func loadView() {
            super.loadView()
            self.title = Messages.login.localised
        }

        // Order in View life-cycle : 4
        override func viewDidLoad() {
            super.viewDidLoad()
        }

        // Order in View life-cycle : 6
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            if firstAppearance {
                interactor?.requestScreenInitialState()
            }
        }

        // Order in View life-cycle : 9
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
        }

        //
        // MARK: Dark Mode
        //

        // Order in View life-cycle : 8
        public override func setupColorsAndStyles() {
            //super.setupColorsAndStyles()
            // Setup UI on dark mode (if needed)
        }

        //
        // MARK: Mandatory methods
        //

        // Order in View life-cycle : 1
        override func setup() {
            // This function is called automatically by super BaseGenericView
            let viewController = self
            let interactor = I.CarTrackLoginInteractor()
            let presenter  = P.CarTrackLoginPresenter()
            let router     = R.CarTrackLoginRouter()
            viewController.interactor = interactor
            viewController.router = router
            interactor.presenter  = presenter
            presenter.viewController = viewController
            router.viewController = viewController
            router.dsCarTrackLogin = interactor
        }

        private lazy var topGenericView: TopBar = {
            let some = TopBar()
            some.injectOn(viewController: self, usingSafeArea: true)
            some.setTitle(Messages.welcome.localised)
            return some
        }()

        // Order in View life-cycle : 5
        // This function is called automatically by super BaseGenericView
        override func setupViewIfNeed() {
            // Use it to configure stuff on the genericView, depending on the value external/public variables
            // that are set after we instantiate the view controller, but before if has been presented
            topGenericView.lazyLoad()
        }

        // Order in View life-cycle : 3
        // This function is called automatically by super BaseGenericView
        override func setupViewUIRx() {

            #warning("adicionar um delay desde que parou de escrever")
            let observable1 = genericView.rxTxtPassword.value.asObservable()
                .debounce(.milliseconds(AppConstants.Rx.textFieldsDefaultDebounce), scheduler: MainScheduler.instance)
            let observable2 = genericView.rxTxtUsername.value.asObservable()
                .debounce(.milliseconds(AppConstants.Rx.textFieldsDefaultDebounce), scheduler: MainScheduler.instance)
            Observable.combineLatest(observable1, observable2).asObservable().bind { [weak self] (password, userName) in
                guard let self = self else { return }
                guard self.isVisible else { return }
                guard let password = password else { return }
                guard let userName = userName else { return }
                let request = VM.CarTrackLogin.ScreenState.Request(userName: userName,
                                                                   password: password,
                                                                   txtUsernameIsFirstResponder: self.genericView.txtUsernameIsFirstResponder,
                                                                   txtPasswordIsFirstResponder: self.genericView.txtPasswordIsFirstResponder)
                self.interactor?.requestScreenState(request: request)
            }.disposed(by: disposeBag)

            genericView.rxBtnLoginTap
                .do(onNext: { [weak self] in
                    self?.genericView.subViewsWith(tag: UIKitViewFactoryElementTag.label.rawValue, recursive: true).forEach({ (some) in
                           (some as? UITextField)?.resignFirstResponder()
                       })
                    let request = VM.CarTrackLogin.Login.Request()
                    self?.interactor?.requestLogin(request: request)
                })
                .subscribe()
                .disposed(by: disposeBag)

        }

        // Order in View life-cycle : 7
        // This function is called automatically by super BaseGenericView
        override func setupNavigationUIRx() {
            // Add options to navigation bar
        }
    }
}

// MARK: Public Misc Stuff

extension VC.CarTrackLoginViewController {
    // THIS FUNCTION IS JUST FOR DEMONSTRATION PURPOSES. DELETE AFTER USING TEMPLATE
    // THIS FUNCTION IS JUST FOR DEMONSTRATION PURPOSES. DELETE AFTER USING TEMPLATE
    // THIS FUNCTION IS JUST FOR DEMONSTRATION PURPOSES. DELETE AFTER USING TEMPLATE
    public func somePublicStuff() {
        // Do some public stuff
    }
}

// MARK: Private Misc Stuff

extension VC.CarTrackLoginViewController {

}

// MARK: DisplayLogicProtocolProtocol

extension VC.CarTrackLoginViewController: CarTrackLoginDisplayLogicProtocol {

    func displayLogin(viewModel: VM.CarTrackLogin.Login.ViewModel) {
        if viewModel.success {
            router?.routeToNextScreen()
        } else {
            
        }
    }

    func displayScreenState(viewModel: VM.CarTrackLogin.ScreenState.ViewModel) {
        // Setting up the view, option 1 : passing the view model
        genericView.setupWith(screenState: viewModel)
    }

    func displayNextButtonState(viewModel: VM.CarTrackLogin.NextButtonState.ViewModel) {
        genericView.setupWith(nextButtonState: viewModel)
    }

    func displayScreenInitialState(viewModel: VM.CarTrackLogin.ScreenInitialState.ViewModel) {
        genericView.setupWith(screenInitialState: viewModel)
    }
}
