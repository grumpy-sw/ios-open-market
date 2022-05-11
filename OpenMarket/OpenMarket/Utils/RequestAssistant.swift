//
//  RequestAssistant.swift
//  OpenMarket
//
//  Created by Grumpy, OneTool on 2022/05/10.
//

import Foundation

final class RequestAssistant {
    private let sessionManager = URLSessionGenerator(session: URLSession.shared)
    
    func requestListAPI(pageNumber: Int, itemsPerPage: Int, completionHandler: @escaping ((Result<ProductList, OpenMarketError>) -> Void)) {
        let path = "api/products"
        let queryString = "?page_no=\(pageNumber)&items_per_page=\(itemsPerPage)"
        
        sessionManager.request(path: path + queryString, completionHandler: { data, response, error in
            guard let data = data else {
                return
            }
            guard let result = try? JSONDecoder().decode(ProductList.self, from: data) else {
                completionHandler(.failure(.failDecode))
                return
            }
            self.handleResponse(response: response, result: result, completionHandler: completionHandler)
        })
    }
    
    func requestDetailAPI(product_id: Int, completionHandler: @escaping ((Result<Product, OpenMarketError>) -> Void)) {
        let path = "api/products/\(product_id)"
        
        sessionManager.request(path: path, completionHandler: { data, response, error in
            guard let data = data else {
                return
            }
            guard let result = try? JSONDecoder().decode(Product.self, from: data) else {
                completionHandler(.failure(.failDecode))
                return
            }
            self.handleResponse(response: response, result: result, completionHandler: completionHandler)
        })
    }
    
    func requestHealthCheckerAPI(completionHandler: @escaping ((Result<String, OpenMarketError>) -> Void)) {
        let path = "healthChecker"
        sessionManager.request(path: path, completionHandler: { data, response, error in
            guard let data = data else {
                return
            }
            if let result = String(data: data, encoding: .utf8) {
                self.handleResponse(response: response, result: result, completionHandler: completionHandler)
            }
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
