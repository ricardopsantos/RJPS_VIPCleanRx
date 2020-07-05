//
//  I.ProductsListInteractor.swift
//  GoodToGo
//
//  Created by Ricardo Santos on 03/07/2020.
//  Copyright (c) 2020 Ricardo P Santos. All rights reserved.
//

import UIKit
import Foundation
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
import Domain_VisionBox
import Extensions
import PointFreeFunctions
import UIBase
import AppResources
import Factory

//
// Interactor will fetch the Domain objects, (from DataManager or WebAPI) and return that response
// to the Presenter. The Presenter will parse then into ViewModel objects
//
// The interactor contains your app’s business logic. The user taps and swipes in your UI in
// order to interact with your app. The view controller collects the user inputs from the UI
// and passes it to the interactor. It then retrieves some models and asks some workers to do the work.
//

extension I {
    class ProductsListInteractor: BaseInteractorVIP, ProductsListDataStoreProtocol {
        deinit {
            DevTools.Log.logDeInit("\(ProductsListInteractor.self) was killed")
            NotificationCenter.default.removeObserver(self)
        }
        var presenter: ProductsListPresentationLogicProtocol?
        weak var basePresenter: BasePresenterVIPProtocol? { return presenter }
        var dsSelectedCategory: VisionBox.Category?
        var dsSelectedProduct: VisionBox.ProductModel?
    }
}

// MARK: Interator Mandatory BusinessLogicProtocol

extension I.ProductsListInteractor: BaseInteractorVIPMandatoryBusinessLogicProtocol {

    /// When the screen is loaded, this function is responsible to bind the View with some (temporary or final) data
    /// till the user have all the data loaded on the view. This will improve user experience.
    func requestScreenInitialState() {
        let products = VisionBox.ProductModel.mockData.filter({$0.category == dsSelectedCategory})
        let response = VM.ProductsList.ScreenInitialState.Response(products: products)
        presenter?.presentScreenInitialState(response: response)
    }

}

// MARK: Private Stuff

extension I.ProductsListInteractor {

}

// MARK: BusinessLogicProtocol

extension I.ProductsListInteractor: ProductsListBusinessLogicProtocol {

    func requestShowProductDetails(viewModel: VM.ProductsList.ShowProductDetails.Request) {
        dsSelectedProduct = viewModel.product
        let response = VM.ProductsList.ShowProductDetails.Response()
        presenter?.presentShowProductDetails(response: response)
    }

    func requestFilterProducts(viewModel: VM.ProductsList.FilterProducts.Request) {
        var products = VisionBox.ProductModel.mockData.filter({ $0.category == dsSelectedCategory })
        if !viewModel.search.isEmpty {
            products = products.filter({ "\($0)".lowercased().contains(subString: viewModel.search.trim.lowercased()) })
        }
        let response = VM.ProductsList.FilterProducts.Response(products: products)
        presenter?.presentSomething(response: response)
    }
}

// MARK: Utils {

extension I.ProductsListInteractor {
    func presentError(error: Error) {
        let response = BaseDisplayLogicModels.Error(title: error.localisedMessageForView)
        basePresenter?.presentError(response: response)
    }
}
