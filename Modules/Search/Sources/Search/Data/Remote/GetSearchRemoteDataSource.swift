//
//  File.swift
//  
//
//  Created by Muhamad Irvan on 06/01/23.
//
// swiftlint:disable force_cast

import PlaydiaCore
import Combine
import Alamofire
import Foundation

public struct GetSearchRemoteDataSource: DataSource {
	let apiUrl = Bundle.main.infoDictionary?["API_URL"] as! String
	let apiKey = Bundle.main.infoDictionary?["API_KEY"] as! String

	public typealias Request = Any
	public typealias Response = [SearchResult]
	private let _endpoint: String
	public init(endpoint: String) {
		_endpoint = endpoint
	}

	public func execute(request: Any?, keyword: String) -> AnyPublisher<[SearchResult], Error> {
		let param = ["key": apiKey, "search": keyword]
		return Future<[SearchResult], Error> { completion in
			if let url = URL(string: _endpoint) {
				AF.request(
					url,
					method: .get,
					parameters: param
				)
				.validate()
				.responseDecodable(of: SearchResponse.self) { response in
					switch response.result {
					case .success(let value):
						completion(.success(value.results ?? []))
					case .failure:
						completion(.failure(URLError.invalidResponse))
					}
				}
			}
		}.eraseToAnyPublisher()
	}

	public func execute(request: Request?) -> AnyPublisher<[SearchResult], Error> {
		fatalError()
	}

	public func execute(request: Request?, id: Int, isFavorite: Bool) -> AnyPublisher<[SearchResult], Error> {
		fatalError()
	}
}
