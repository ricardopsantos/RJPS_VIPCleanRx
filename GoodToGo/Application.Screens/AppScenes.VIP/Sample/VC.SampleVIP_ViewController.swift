//
//  SampleVIP_ViewController.swift
//  GoodToGo
//
//  Created by Ricardo Santos on 10/10/2019.
//  Copyright (c) 2019 Ricardo P Santos. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import Foundation
//
import RJPSLib
import RxSwift
import RxCocoa
//
import AppResources
import UIBase
import AppTheme
import AppConstants
import Extensions
import DevTools
import PointFreeFunctions

//
// Add
//  * deinit
//  * loadView
//  * prepareLayout
//
// Remove
//  * prepare(for segue: UIStoryboardSegue, sender: Any?)

// Adicionar botao de router para mudar de ecran

protocol SampleVIP_DisplayLogic: class {
  func displaySomething(viewModel: SampleVIP.SearchView.ViewModel)
}

class SampleVIP_ViewController: GenericView, SampleVIP_DisplayLogic {
  var interactor: SampleVIP_BusinessLogic?
  var router: (NSObjectProtocol & SampleVIP_RoutingLogic & SampleVIP_DataPassing)?

    // Added to template
    deinit {
            AppLogger.log("\(self.className) was killed")
            NotificationCenter.default.removeObserver(self)
        }
        
    private lazy var _searchBar: CustomSearchBar = {
        let some = AppFactory.UIKit.searchBar(baseView: self.view)
        some.rjsALayouts.setMargin(0, on: .top)
        some.rjsALayouts.setMargin(0, on: .right)
        some.rjsALayouts.setMargin(0, on: .left)
        some.rjsALayouts.setHeight(50)
        some.rx.textDidEndEditing
            .subscribe(onNext: { [weak self] (_) in
                guard let self = self else { AppLogger.log(appCode: .referenceLost); return }
                if self._searchBar.text!.count>0 {
               //     self.presenter.searchUserWith(username: some.text ?? "")
                }
            })
            .disposed(by: self.disposeBag)
        return some
    }()

  // MARK: Object lifecycle
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: Setup
  
    // Added to template
    override func prepareLayout() {
         super.prepareLayout()
         self.view.backgroundColor = AppColors.appDefaultBackgroundColor
         _searchBar.lazyLoad()
     }
    
  private func setup() {
    let viewController = self
    let interactor = SampleVIP_Interactor()
    let presenter = SampleVIP_Presenter()
    let router = SampleVIP_Router()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  
  // MARK: Routing

  // MARK: View lifecycle
  
    // Added
    override func loadView() {
        super.loadView()
        prepareLayout()
    }
    
  override func viewDidLoad() {
    super.viewDidLoad()

    DispatchQueue.executeWithDelay(delay: 3) {
        self.doSomething()
    }
    
  }
  
  // MARK: Do something
  
  //@IBOutlet weak var nameTextField: UITextField!
  
  func doSomething() {
    let request = SampleVIP.SearchView.Request()
    interactor?.doSomething(request: request)
  }
  
  func displaySomething(viewModel: SampleVIP.SearchView.ViewModel) {
    _searchBar.text = viewModel.name
  }
}
