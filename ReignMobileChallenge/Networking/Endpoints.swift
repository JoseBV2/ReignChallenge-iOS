//
//  Endpoints.swift
//  ReignMobileChallenge
//
//  Created by Jóse Bustamante on 20/09/22.
//

import Foundation

enum Endpoints {
    
    case comments
    
    var url: String {
        switch self {
        case .comments:
            return "https://hn.algolia.com/api/v1/search_by_date?query=mobile"
        }
    }
}

