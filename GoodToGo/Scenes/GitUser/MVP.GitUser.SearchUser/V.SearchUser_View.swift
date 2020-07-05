//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import UIKit
import Foundation
import SwiftUI
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
import Designables

public extension V {
    internal class SearchUser_View: BaseViewControllerMVP {
        
        deinit {
            DevTools.Log.logDeInit("\(self.className) was killed")
            NotificationCenter.default.removeObserver(self)
            presenter.generic?.view_deinit()
        }
        var presenter: SearchUser_PresenterProtocol!
        
        private lazy var topGenericView: TopBar = {
            let some = UIKitFactory.topBar(baseController: self, usingSafeArea: true)
            some.setTitle("Search GitHub user")
            return some
        }()
        
        private lazy var searchBar: CustomSearchBar = {
            let some = UIKitFactory.searchBar(baseView: self.view, placeholder: Messages.search.localised)
            some.rjsALayouts.setMargin(0, on: .top, from: topGenericView.view)
            some.rjsALayouts.setMargin(0, on: .right)
            some.rjsALayouts.setMargin(0, on: .left)
            some.rjsALayouts.setHeight(50)
            some.rx.text
                .orEmpty
                .debounce(.milliseconds(AppConstants.Rx.textFieldsDefaultDebounce), scheduler: MainScheduler.instance)
                .log(whereAmI())
                .subscribe(onNext: { [weak self] _ in
                    guard let self = self else { return }
                    self.presenter.searchUserWith(username: some.text ?? "")
                })
                .disposed(by: disposeBag)
            some.rx
                .textDidEndEditing
                .log(whereAmI())
                .subscribe(onNext: { [weak self] (_) in
                    guard let self = self else { return }
                    if self.searchBar.text!.count>0 {
                        self.presenter.searchUserWith(username: some.text ?? "")
                    }
                })
                .disposed(by: self.disposeBag)
            return some
        }()
        
        public override func loadView() {
            super.loadView()
            presenter.generic?.loadView()
            view.accessibilityIdentifier = self.genericAccessibilityIdentifier

            if #available(iOS 13.0, *) {
                // Always light.
                let lightView = self.view
                lightView!.overrideUserInterfaceStyle = .light
                // Always dark.
                let darkView = self.view
                darkView!.overrideUserInterfaceStyle = .dark
                // Follows the appearance of its superview.
                //let unspecifiedView = self.view
                view.overrideUserInterfaceStyle = .unspecified
                self.view = darkView
                //let isDark = traitCollection.userInterfaceStyle == .dark
            }
            
        }
        
        open override func viewDidLoad() {
            super.viewDidLoad()
            presenter.generic?.viewDidLoad()
        }
        
        open override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            presenter.generic?.viewWillAppear()
            DevTools.Log.error("Error")
        }
        
        open override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            presenter.generic?.viewDidAppear()
            searchBar.becomeFirstResponder()
        }
        
        public override func prepareLayoutCreateHierarchy() {
            self.view.backgroundColor = AppColors.backgroundColor
            topGenericView.lazyLoad()
            searchBar.lazyLoad()
        }
        
        public override func prepareLayoutBySettingAutoLayoutsRules() {
            
        }
        
        public override func prepareLayoutByFinishingPrepareLayout() {
            
        }
    }
}

// MARK: - View Protocol

extension GoodToGo.V.SearchUser_View: SearchUser_ViewProtocol {
    func viewDataToScreen(some: GoodToGo.VM.SearchUser) {
        searchBar.text = some.user
    }
}

// MARK: - Preview

struct SearchUser_UIViewControllerRepresentable: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> GoodToGo.V.SearchUser_View {
        let vc = GoodToGo.V.SearchUser_View()
        return vc
    }

    func updateUIViewController(_ uiViewController: GoodToGo.V.SearchUser_View, context: Context) {

    }
}

struct SearchUser_Previews: PreviewProvider {
    @available(iOS 13.0.0, *)
    static var previews: some SwiftUI.View {
        return SearchUser_UIViewControllerRepresentable()
    }
}