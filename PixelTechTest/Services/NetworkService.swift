//
//  NetworkService.swift
//  PixelTechTest
//
//  Created by Phil Margetson on 18/01/2026.
//
import Foundation

enum NetworkError: Error {
    case badRequest
    case badResponse
    case decodingFailed
    case noInternet
}

protocol NetworkServiceProtocol {
    func getData<T: Decodable>(from endpoint: Endpoint) async throws -> T
}

final class MockNetworkService: NetworkServiceProtocol {
    
    private var successResponses: [Endpoint: Any] = [:]
    private var errorResponses: [Endpoint: Error] = [:]
    
    enum TestError: Error {
        case missingExpectedResponse
    }
    
    func addSuccessResponse<T: Decodable>(_ response: T, for endpoint: Endpoint) {
        self.successResponses[endpoint] = response
    }
    
    func addErrorResponse(_ error: Error, for endpoint: Endpoint) {
        self.errorResponses[endpoint] = error
    }
    
    func getData<T>(from endpoint: Endpoint) async throws -> T where T : Decodable {
        if let errorResponse = errorResponses.first(where: {$0.key == endpoint})?.value {
            throw errorResponse
        } else if let successResponse = successResponses.first(where: {$0.key == endpoint})?.value as? T {
            return successResponse
        } else {
            throw TestError.missingExpectedResponse
        }
    }
}

final class NetworkService: NetworkServiceProtocol {
    
    func getData<T: Decodable>(from endpoint: Endpoint) async throws -> T {
        guard let urlRequest = endpoint.asURLRequest() else {
            throw NetworkError.badRequest
        }
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
            throw NetworkError.badResponse
        }
        let decodedData = try JSONDecoder().decode(T.self, from: data)
        return decodedData
    }
}
