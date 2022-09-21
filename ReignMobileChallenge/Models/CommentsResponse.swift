//
//  CommentsResponse.swift
//  ReignMobileChallenge
//
//  Created by Jóse Bustamante on 20/09/22.
//

import Foundation

struct CommentsResponse: Codable {
    var hits: [CommentsHitsResponse]
}

struct CommentsHitsResponse: Codable {
    let author: String
    let commentText: String?
    let createdAt: String
    let storyTitle: String?
    let storyUrl: String?
    let createdAtI: Int
    
    func formattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = Date(timeIntervalSince1970: TimeInterval(createdAtI))
        var sentence = date.timeAgoDisplay()
        let wordToRemove = "ago"


        if let range = sentence.range(of: wordToRemove) {
           sentence.removeSubrange(range)
        }
        return sentence
    }
}
    
