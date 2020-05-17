//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
//
import RxSwift
import RxCocoa
import RJPSLib
//
import AppConstants
import PointFreeFunctions

public protocol GenericTableViewCell_Protocol: ReusableCell_Protocol {
    func set(title: String)     // Mandatory
    func set(image: UIImage?)
    func set(textColor: UIColor)
}

public extension GenericTableViewCell_Protocol {
    func set(image: UIImage?) { }
    func set(textColor: UIColor) { }
}

public protocol ReusableCell_Protocol {
    static var reuseIdentifier: String { get }
}

public extension ReusableCell_Protocol {
    static var reuseIdentifier: String { return String(describing: self)+".\(AppConstants.Dev.cellIdentifier)" }
}
