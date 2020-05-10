//
//  GoodToGo
//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
import RJPSLib

public typealias SampleB_UseCaseCompletionHandler = (_ result: Result<[Employee.ResponseDto]>) -> Void
public protocol SampleB_UseCaseProtocol: class {
    func operation1(canUseCache: Bool, completionHandler: @escaping SampleB_UseCaseCompletionHandler)
    func operation2(param: String, completionHandler: @escaping SampleB_UseCaseCompletionHandler)
}