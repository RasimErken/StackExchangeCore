//
//  AnswerViewModel.swift
//  StackExchangeApı
//
//  Created by rasim rifat erken on 15.09.2022.
//
import Foundation
import UIKit

struct QuestionResponse: Codable {
    let items: [QuestionItemsData]

    enum CodingKeys: String, CodingKey {
        case items
    }
}

struct QuestionItemsData: Codable {
    let tags: [String]?
    let owner: QuestionOwner?
    let creationDate: Int?
    let questionID: Int?
    let title: String?

    enum CodingKeys: String, CodingKey {
        case tags, owner
        case creationDate = "creation_date"
        case questionID = "question_id"
        case title
    }
    
    init(from decoder:Decoder) throws{

            let container = try decoder.container(keyedBy: CodingKeys.self)

            title = try container.decodeIfPresent(String.self, forKey: .title)
            questionID = try container.decodeIfPresent(Int.self, forKey: .questionID)
            creationDate = try container.decodeIfPresent(Int.self, forKey: .creationDate)
            owner = try container.decodeIfPresent(QuestionOwner.self, forKey: .owner)
            tags = try container.decodeIfPresent([String].self, forKey: .tags)
    }
    
    

    func questionCreationDate() -> String {
        return "asked on \(Double(creationDate!).getDateStringFromUTC("MMM dd, yyy"))"
    }
    
    func questionTags() -> String {
        return tags?.joined(separator: ", ") ?? ""
    }
}

struct QuestionOwner: Codable {
    let reputation: Int?
    let profileImage: String?
    let displayName: String?


    enum CodingKeys: String, CodingKey {
        case reputation
        case profileImage = "profile_image"
        case displayName = "display_name"

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
