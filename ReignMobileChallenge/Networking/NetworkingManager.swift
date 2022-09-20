//
//  NetworkingManager.swift
//  ReignMobileChallenge
//
//  Created by Jóse Bustamante on 20/09/22.
//

import Alamofire
import Foundation

protocol NetworkingManagerProtocol {
    
    /// Performs a network request returning a `result` that contains a success or failure.
    ///
    /// - Parameters:
    ///     - url: An string.
    ///     - type: An struct element. It must conform `decodable` protocol.
    ///     - callback: A result that contains a success or failure event.
    func makeServerRequest<Element: Decodable>(_ url: URLConvertible,
                                               _ type: Element.Type,
                                               _ callback: @escaping (Result<Element, Error>) -> Void)
}

final class NetworkingManager: NetworkingManagerProtocol {
    
    // MARK: - Singleton
    
    static let shared = NetworkingManager()
    
    // MARK: - Lifecycle
    
    private init() { }
    
    // MARK: - Protocol Methods
    
    func makeServerRequest<Element>(_ url: URLConvertible, _ type: Element.Type, _ callback: @escaping (Result<Element, Error>) -> Void) where Element : Decodable {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        AF.request(url)
            .validate()
            .responseDecodable(of: type.self, decoder: decoder) { serverResponse in
                if let error = serverResponse.error {
                    callback(.failure(error))
                    return
                }
                
                if let object = serverResponse.value {
                    callback(.success(object))
                    return
                }
                
                // Any other case returns error.
                let nsError = NSError(domain: "An unexpected error ocurred.", code: 0, userInfo: nil)
                callback(.failure(nsError))
            }
    }
}

