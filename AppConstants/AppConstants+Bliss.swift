//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import UIKit
//
import RJPSLib

// swiftlint:disable line_length

public extension AppConstants {

    struct Bliss {
        public static let logoURL: String = "https://static.itjobs.pt/images/companies/57/1d3/1475/logo.png?btfc=1498121844" //"https://media.licdn.com/dms/image/C560BAQF48lgMCIY3FA/company-logo_200_200/0?e=2159024400&v=beta&t=OD27mw1uDClWEJLmtz7wU8TFg9Hod2Yd1p1Wx6Zl0Eo"

        public struct URLs {
            public static var blissAPIBaseUrl: String {
                let defaultValue = "https://private-anon-f659e751cc-blissrecruitmentapi.apiary-mock.com"
                //switch AppEnvironments.current {
                //case .dev  : return defaultValue
                //case .prod : return defaultValue
                //case .qa   : return defaultValue
                //}
                return defaultValue
            }
        }

        public struct DeepLinks {
            public static let questionsFilter = "question_filter" // DONT CHANGE VALUE
            public static let questionId      = "question_id"     // DONT CHANGE VALUE
        }
    }
}
