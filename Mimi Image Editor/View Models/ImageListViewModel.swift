//
//  ImageListViewModel.swift
//  Mimi Image Editor
//
//  Created by Federico on 27/09/2020.
//  Copyright © 2020 Federico Maza. All rights reserved.
//

import Foundation
import SwiftUI

class ImageListViewModel: ObservableObject {
	@Published var identifiers = [PicsumImageIdentifier]()
	@Published var searchTerm = ""
	
	func addIdentifier(_ identifier: String) {
		guard let element = Int(identifier) else {
			return
		}
		
		DispatchQueue.main.async {
			self.objectWillChange.send()
			self.identifiers.append(PicsumImageIdentifier(photo: element))
		}
	}
}
