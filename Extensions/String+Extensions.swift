//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import UIKit
import Foundation

extension String {
    var capitalized: String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
