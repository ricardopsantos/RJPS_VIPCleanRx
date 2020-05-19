//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import Foundation
//
import UIKit
import RxSwift
import RJPSLib
import RxCocoa
//
import DevTools

open class BasePresenterMVP {
    deinit {
        if DevTools.FeatureFlag.devTeam_logDeinit.isTrue { DevTools.Log.log("\(self) was killed") }
        NotificationCenter.default.removeObserver(self)
    }
    public init () {}
    public var rxPublishRelay_error = PublishRelay<Error>()
    public var reachabilityService: ReachabilityService! = DevTools.reachabilityService
    public var disposeBag: DisposeBag = DisposeBag()
   
}
