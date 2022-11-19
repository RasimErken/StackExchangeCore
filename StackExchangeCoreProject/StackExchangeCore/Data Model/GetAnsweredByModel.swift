//
//  AnswerViewModel.swift
//  StackExchangeApı
//
//  Created by rasim rifat erken on 15.09.2022.
//

import Foundation
import UIKit

struct GetAnsweredByResponse: Codable {
    let items: [GetAnsweredItemsData]

    enum CodingKeys: String, CodingKey {
        case items
    }
}

struct GetAnsweredItemsData: Codable {
    let owner: GetAnsweredOwner?
    let questionID:Int?
    let score: Int?
    let creationDate: Int?
    let answerID:Int?

    
    enum CodingKeys: String, CodingKey {
        case owner
        case score
        case creationDate = "creation_date"
        case questionID = "question_id"
        case answerID = "answer_id"
    }
    
    init(from decoder:Decoder) throws{
           
            let container = try decoder.container(keyedBy: CodingKeys.self)
           
            answerID = try container.decodeIfPresent(Int.self, forKey: .answerID)
            questionID = try container.decodeIfPresent(Int.self, forKey: .questionID)
            creationDate = try container.decodeIfPresent(Int.self, forKey: .creationDate)
            owner = try container.decodeIfPresent(GetAnsweredOwner.self, forKey: .owner)
            score = try container.decodeIfPresent(Int.self, forKey: .score)
    }
    
    func questionCreationDate() -> String {
        return "Answered on \(Double(creationDate!).getDateStringFromUTC("MMM dd, yyy"))"
    }
}

struct GetAnsweredOwner: Codable {
    let reputation: Int?
    let profileImage: String?
    let displayName: String?
//    let questionID : Int?

    enum CodingKeys: String, CodingKey {
        case reputation
        case profileImage = "profile_image"
        case displayName = "display_name"
//        case questionID = "question_id"
    }
    
    init(from decoder:Decoder) throws{
            
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            reputation = try container.decodeIfPresent(Int.self, forKey: .reputation)
            profileImage = try container.decodeIfPresent(String.self, forKey: .profileImage)
            displayName = try container.decodeIfPresent(String.self, forKey: .displayName)
            
    }
    
    func ownerReputations() -> String {
        return "Reputation: \(reputation ?? 0)"
    }
}
