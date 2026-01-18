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
