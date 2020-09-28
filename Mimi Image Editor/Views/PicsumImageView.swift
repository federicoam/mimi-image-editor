//
//  PicsumImageView.swift
//  Mimi Image Editor
//
//  Created by Federico on 28/09/2020.
//  Copyright © 2020 Federico Maza. All rights reserved.
//

import SwiftUI


import SwiftUI

struct PicsumImageView: View {
	@StateObject var viewModel = PicsumImageViewModel()
	
	@State private var identifier = 0 
	@State private var showingSaveAlert = false
	
	init(with identifier: Int) {
		self._identifier = .init(initialValue: identifier)
	}
	
	var body: some View {
		VStack {
			Button(action: {
				let imageSaver = ImageSaver()
				
				imageSaver.successHandler = {
					self.showingSaveAlert = true
				}
				
				imageSaver.errorHandler = {
					print("Oops: \($0.localizedDescription)")
				}
				
				imageSaver.writeToPhotoAlbum(image: self.viewModel.image)
			}, label: {
				Image(uiImage: viewModel.image)
					.resizable()
					.scaledToFill()
			})
			.alert(isPresented: $showingSaveAlert) {
				Alert(
					title: Text("Image saved"),
					message: Text("The image has been saved to the photo album."),
					dismissButton: .default(Text("Dismiss"))
				)
			}
		}
		.onAppear {
			viewModel.fetchPicsumImage(with: self.identifier)
		}
	}
}

struct PicsumImageViewPreview: PreviewProvider {
	static var previews: some View {
		PicsumImageView(with: 1000)
	}
}
