//
//  CommentsViewModel.swift
//  ReignMobileChallenge
//
//  Created by Jóse Bustamante on 20/09/22.
//

import UIKit

protocol CommentsViewProtocol: AnyObject {
    var delegate: CommentsViewDelegate? { get set }
    var isAlreadyFetched: Bool? { get set }
    func getComments()
    func numberOfItems() -> Int
    func numberOfSection() -> Int
    func getCurrentComment(at indexPath: IndexPath) -> CommentsHitsResponse
    func setCommentsValue()
    func removeSpecificComments(at index: IndexPath)
}

protocol CommentsViewDelegate: AnyObject {
    func didRequestSucceded()
    func didFailure(error: Error)
    func showAlert()
}

final class CommentsViewModel: CommentsViewProtocol {
    
    var delegate: CommentsViewDelegate?
    private var hits: [CommentsHitsResponse] = []
    var isAlreadyFetched: Bool?
    
    func getComments() {
        if isAlreadyFetched == true {
            delegate?.didRequestSucceded()
            return
        }
        NetworkingManager
            .shared
            .makeServerRequest(Endpoints.comments.url, CommentsResponse.self) { [weak self] result in
                switch result {
                case .success(let result):
                    self?.hits = result.hits
                    UserDefaults.standard.set(try? PropertyListEncoder().encode(self?.hits), forKey: "data")
                    self?.isAlreadyFetched = true
                    self?.delegate?.didRequestSucceded()
                case .failure(let error):
                    self?.delegate?.didFailure(error: error)
                }
            }
    }
    
    func numberOfItems() -> Int {
        return hits.count
    }
    
    func numberOfSection() -> Int {
        return 1
    }
    
    func getCurrentComment(at indexPath: IndexPath) -> CommentsHitsResponse {
        return hits[indexPath.row]
    }
    
    func setCommentsValue() {
        guard let data = UserDefaults.standard.value(forKey:"data") as? Data else {
            return
        }
        let comments = try? PropertyListDecoder().decode(Array<CommentsHitsResponse>.self, from: data)
        guard let comments = comments else {
            self.delegate?.showAlert()
            return
        }
        self.hits = comments
        
        if comments.isEmpty {
            isAlreadyFetched = false
        } else {
            isAlreadyFetched = true
        }
    }
    
    func removeSpecificComments(at index: IndexPath) {
        self.hits.remove(at: index.row)
        UserDefaults.standard.set(try? PropertyListEncoder().encode(self.hits), forKey: "data")
    }
}
