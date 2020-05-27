//
//  GoodToGo
//
//  Created by Ricardo P Santos
//  Copyright ©  Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit
//
import Domain

//
// Generate by https://app.quicktype.io/
//

public extension Bliss {
    
    // MARK: - ResponseElement
    struct QuestionElementResponseDto: ResponseDtoProtocol {
        public let id: Int
        public let question: Question
        public let imageURL: String
        public let thumbURL: String
        public let publishedAt: PublishedAt
        public let choices: [ChoiceElementResponseDto]
        
        enum CodingKeys: String, CodingKey {
            case id, question
            case imageURL = "image_url"
            case thumbURL = "thumb_url"
            case publishedAt = "published_at"
            case choices
        }
    }
    
    // MARK: - ChoiceElement
    struct ChoiceElementResponseDto: ResponseDtoProtocol {
        public let choice: ChoiceEnum
        public let votes: Int
    }
    
    enum ChoiceEnum: String, ResponseDtoProtocol {
        case objectiveC = "Objective-C"
        case python = "Python"
        case ruby = "Ruby"
        case swift = "Swift"
    }
    
    enum PublishedAt: String, ResponseDtoProtocol {
        case the20150805T084051620Z = "2015-08-05T08:40:51.620Z"
    }
    
    enum Question: String, ModelEntityProtocol {
        case favouriteProgrammingLanguage = "Favourite programming language?"
    }
}

public extension Bliss.QuestionElementResponseDto {
    static func make() -> Bliss.QuestionElementResponseDto {
        let question = Bliss.Question.favouriteProgrammingLanguage
        let choices1 = Bliss.ChoiceElementResponseDto(choice: Bliss.ChoiceEnum.python, votes: 0)
        let choices2 = Bliss.ChoiceElementResponseDto(choice: Bliss.ChoiceEnum.objectiveC, votes: 0)
        let choices  = [choices1, choices2]
        let imageURL = "www.google.pt"
        let thumbURL = "www.google.pt"
        let questionElement = Bliss.QuestionElementResponseDto(id: 0, question: question, imageURL: imageURL, thumbURL: thumbURL, publishedAt: .the20150805T084051620Z, choices: choices)
        return questionElement
    }
}
