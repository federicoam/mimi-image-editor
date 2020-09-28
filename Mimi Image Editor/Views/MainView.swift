//
//  MainView.swift
//  Mimi Image Editor
//
//  Created by Federico on 28/09/2020.
//  Copyright © 2020 Federico Maza. All rights reserved.
//

import SwiftUI

struct MainView: View {
    var body: some View {
		TabView {
			FilterView()
				.tabItem {
					Image(systemName: "photo")
					Text("Image editor")
				}
				.tag(0)
			
			ImageListView()
				.tabItem {
					Image(systemName: "list.dash")
					Text("Image list")
				}
				.tag(1)
		}
    }
}

struct MainViewPreview: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
