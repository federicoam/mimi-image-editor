//
//  ImageListView.swift
//  Mimi Image Editor
//
//  Created by Federico on 27/09/2020.
//  Copyright © 2020 Federico Maza. All rights reserved.
//

import SwiftUI

struct ImageListView : View {
	@State private var searchTerm = ""
	@StateObject private var viewModel = ImageListViewModel()
	
	var body: some View {
		NavigationView {
			VStack {
				Form {
					TextField("Search Picsum image by ID", text: $searchTerm)
						.keyboardType(.numberPad)
					
					Section {
						Button(action: {
							viewModel.addIdentifier(searchTerm)
							searchTerm = ""
							
							UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
						}, label: {
							Text("Add it to the list")
						})
					}
				}
				.frame(width: .infinity, height: 200)
				
				Text("Press on an image to save it to the Photo Album for later edition.")
					.font(.caption)
				
				List(viewModel.identifiers) { identifier in
					PicsumImageView(with: identifier.photo)
						.frame(width: .infinity, height: 200)
						.clipped()
					
					.listRowInsets(EdgeInsets())
					.onAppear {
						UITableView.appearance().backgroundColor = .clear
					}
				}
			}
			
			.navigationBarTitle("Picsum images")
			.background(Color(.systemGray6))
		}
	}
}

struct ImageListViewPreview: PreviewProvider {
	static var previews: some View {
		ImageListView()
	}
}
