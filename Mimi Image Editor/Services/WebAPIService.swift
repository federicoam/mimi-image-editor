//
//  WebAPIService.swift
//  Mimi Image Editor
//
//  Created by Federico on 27/09/2020.
//  Copyright © 2020 Federico Maza. All rights reserved.
//

import Foundation

class WebAPIService {
	func fetch(from serviceURL: URL, completion: @escaping (Result<Data, Error>) -> ()) {
		var URLLoadRequest: URLRequest {
			var URLLoadRequest = URLRequest(url: serviceURL)
			
			URLLoadRequest.httpMethod = "GET"
			
			return URLLoadRequest
		}
		
		let dataTask = URLSession.shared.dataTask(with: URLLoadRequest) { data, response, error in
			guard let data = data else {
				return
			}
			
			DispatchQueue.main.async {
				completion(.success(data))
			}
		}
		
		dataTask.resume()
	}
}
