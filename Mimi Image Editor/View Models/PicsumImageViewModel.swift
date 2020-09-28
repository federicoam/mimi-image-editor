//
//  PicsumImageViewModel.swift
//  Mimi Image Editor
//
//  Created by Federico on 28/09/2020.
//  Copyright © 2020 Federico Maza. All rights reserved.
//

import Foundation
import SwiftUI

class PicsumImageViewModel: ObservableObject {
	@Published var image = UIImage()
	
	private let webAPIService = WebAPIService()
	
	func fetchPicsumImage(with identifier: Int) {
		guard let imageURL = URL(string: "https://picsum.photos/id/\(identifier)/400/400") else {
			return
		}
		
		webAPIService.fetch(from: imageURL) { response in
			switch response {
				case .success(let data):
					self.image = UIImage(data: data)!
				case .failure(_):
					break
			}
		}
	}
}
