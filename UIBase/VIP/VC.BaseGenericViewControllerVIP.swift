//
//  BaseGenericViewControllerVIP.swift
//  UIBase
//
//  Created by Ricardo Santos on 11/05/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
//
import RxCocoa
import RxSwift
import DevTools
import PointFreeFunctions

open class BaseGenericViewControllerVIP<T: StylableView>: BaseViewControllerVIP {

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    public var disposeBag = DisposeBag()
    public var firstAppearance: Bool = true
    public var genericView: T { return view as! T }
    open override func loadView() {
        super.loadView()
        view = T()
        setupViewUIRx()
    }

    open func setup() {
        assert(false, message: DevTools.Strings.overrideMe.rawValue)
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        setupViewIfNeed()
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationUIRx()
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        firstAppearance = false
    }

    open func setupViewIfNeed() {
        assert(false, message: DevTools.Strings.overrideMe.rawValue)
    }

    open func setupNavigationUIRx() {
        assert(false, message: DevTools.Strings.overrideMe.rawValue)
    }

    open func setupViewUIRx() {
        assert(false, message: DevTools.Strings.overrideMe.rawValue)
    }
}