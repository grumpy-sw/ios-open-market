//
//  RequestAssistant.swift
//  OpenMarket
//
//  Created by Grumpy, OneTool on 2022/05/10.
//

import UIKit

final class RequestAssistant {
    static let shared = RequestAssistant()
    private let sessionManager = URLSessionGenerator(session: URLSession.shared)
    
    private init() { }
    
    func requestListAPI(pageNumber: Int, itemsPerPage: Int, completionHandler: @escaping ((Result<ProductList, OpenMarketError>) -> Void)) {
        
        let endpoint: Endpoint = .productList(nubmers: pageNumber, pages: itemsPerPage)
        
        sessionManager.request(endpoint: endpoint, completionHandler: { [weak self] data, response, error in
            guard let data = data else {
                return
            }
            guard let result = try? Decoder.shared.decode(ProductList.self, from: data) else {
                completionHandler(.failure(.failDecode))
                return
            }
            self?.handleResponse(response: response, result: result, completionHandler: completionHandler)
        })
    }
    
    func requestDetailAPI(productId: Int, completionHandler: @escaping ((Result<Product, OpenMarketError>) -> Void)) {
        let endpoint: Endpoint = .productDetail(productId: productId)
        
        sessionManager.request(endpoint: endpoint, completionHandler: { [weak self] data, response, error in
            guard let data = data else {
                return
            }
            guard let result = try? Decoder.shared.decode(Product.self, from: data) else {
                completionHandler(.failure(.failDecode))
                return
            }
            self?.handleResponse(response: response, result: result, completionHandler: completionHandler)
        })
    }
    
    func requestHealthCheckerAPI(completionHandler: @escaping ((Result<String, OpenMarketError>) -> Void)) {
        let endpoint: Endpoint = .healthCheck
        sessionManager.request(endpoint: endpoint, completionHandler: { [weak self] data, response, error in
            guard let data = data else {
                return
            }
            if let result = String(data: data, encoding: .utf8) {
                self?.handleResponse(response: response, result: result, completionHandler: completionHandler)
            }
        })
    }
    
    func requestModifyAPI(productId: Int, body: String, identifier: String, completionHandler: @escaping ((Result<Product, OpenMarketError>) -> Void)) {
        let endpoint: Endpoint = .modifyProduct(productId: productId)
        
        sessionManager.request(endpoint: endpoint, body: body, identifier: identifier, completionHandler: { [weak self] data, response, error in
            guard let data = data else {
                return
            }
            guard let result = try? Decoder.shared.decode(Product.self, from: data) else {
                completionHandler(.failure(.failDecode))
                return
            }
            self?.handleResponse(response: response, result: result, completionHandler: completionHandler)
        })
    }
    
    func requestRegisterAPI(body: Data, identifier: String, completionHandler: @escaping ((Result<Product, OpenMarketError>) -> Void)) {
        let endpoint: Endpoint = .registerProudct
        
        sessionManager.request(endpoint: endpoint, body: body, identifier: identifier, completionHandler: { [weak self] data, response, error in
            print(String(data: data!, encoding: .utf8))
            guard let data = data else {
                return
            }
            guard let result = try? Decoder.shared.decode(Product.self, from: data) else {
                completionHandler(.failure(.failDecode))
                return
            }
            self?.handleResponse(response: response, result: result, completionHandler: completionHandler)
        })
    }
    
    private func handleResponse<T>(response: URLResponse?, result: T ,completionHandler: @escaping ((Result<T, OpenMarketError>) -> Void)) {
        guard let response = response as? HTTPURLResponse else {
            return
        }
        let statusCode = response.statusCode
        switch statusCode {
        case 200...299:
            completionHandler(.success(result))
        case 400:
            completionHandler(.failure(.invalidData))
        case 404:
            completionHandler(.failure(.missingDestination))
        case 500...599:
            completionHandler(.failure(.invalidResponse))
        default:
            completionHandler(.failure(.unknownError))
        }
    }
}

enum Endpoint {
    case productList(nubmers: Int, pages: Int)
    case productDetail(productId: Int)
    case healthCheck
    case modifyProduct(productId: Int)
    case registerProudct
}

extension Endpoint {
    var url: URL? {
        switch self {
        case .productList(let numbers, let pages):
            return .makeForEndpoint("/api/products?page_no=\(numbers)&items_per_page=\(pages)")
        case .productDetail(let productId):
            return .makeForEndpoint("/api/products/\(productId)")
        case .healthCheck:
            return .makeForEndpoint("/healthChecker")
        case .modifyProduct(let productId):
            return .makeForEndpoint("/api/products/\(productId)")
        case .registerProudct:
            return .makeForEndpoint("/api/products")
        }
    }
    
    var method: String {
        switch self {
        case .productList(_, _), .productDetail(_), .healthCheck:
            return "GET"
        case .modifyProduct(_):
            return "PATCH"
        case .registerProudct:
            return "POST"
        }
    }
}

extension URL {
    static let baseURL = "https://market-training.yagom-academy.kr"
    
    static func makeForEndpoint(_ endpoint: String) -> URL? {
        URL(string: baseURL + endpoint)
    }
}

final class Decoder {
    static let shared = Decoder().decoder
    private let decoder = JSONDecoder()
    
    private init() {
        let dateFormat: DateFormatter = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd'T'hh:mm:ss.SS"
        decoder.dateDecodingStrategy = .formatted(dateFormat)
    }
}
