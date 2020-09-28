//
//  FilterView.swift
//  Mimi Image Editor
//
//  Created by Federico Maza on 26/09/2020.
//  Copyright © 2020 Federico Maza. All rights reserved.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

struct FilterView: View {
	@State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    @State private var filterIntensity = 0.5
	@State private var image: Image?
	@State private var inputImage: UIImage?
	@State private var processedImage: UIImage?
    @State private var showingFilterSheet = false
    @State private var showingImagePicker = false
	@State private var showingSaveAlert = false

    private let context = CIContext()

    var body: some View {
        let intensity = Binding<Double>(
            get: {
                self.filterIntensity
            },
            set: {
                self.filterIntensity = $0
                self.applyProcessing()
            }
        )

        return NavigationView {
            VStack {
                ZStack {
                    Rectangle()
                        .fill(Color.secondary)

                    if image == nil {
						Text("Tap to select a picture from the album")
							.foregroundColor(.white)
							.font(.headline)
                    } else {
						image?
							.resizable()
							.scaledToFit()
                    }
                }
                .onTapGesture {
                    self.showingImagePicker = true
                }

                HStack {
                    Text("Intensity")
                    Slider(value: intensity)
                }
				.padding(.vertical)

                HStack {
                    Button("Change the filter") {
                        self.showingFilterSheet = true
                    }

                    Spacer()

                    Button("Save it to the album") {
                        guard let processedImage = self.processedImage else { return }

                        let imageSaver = ImageSaver()

                        imageSaver.successHandler = {
							self.showingSaveAlert = true
                        }

                        imageSaver.errorHandler = {
                            print("Oops: \($0.localizedDescription)")
                        }

                        imageSaver.writeToPhotoAlbum(image: processedImage)
                    }
					.alert(isPresented: $showingSaveAlert) {
						Alert(
							title: Text("Image saved"),
							message: Text("The imaged has been saved to the photo album."),
							dismissButton: .default(Text("Dismiss"))
						)
					}
                }
            }
            .padding([.horizontal, .bottom])
            .navigationBarTitle("Image editor")
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: self.$inputImage)
            }
            .actionSheet(isPresented: $showingFilterSheet) {
                ActionSheet(title: Text("Select a filter"), buttons: [
                    .default(Text("Crystallize")) { self.setFilter(CIFilter.crystallize()) },
                    .default(Text("Edges")) { self.setFilter(CIFilter.edges()) },
                    .default(Text("Gaussian Blur")) { self.setFilter(CIFilter.gaussianBlur()) },
                    .default(Text("Pixellate")) { self.setFilter(CIFilter.pixellate()) },
                    .default(Text("Sepia Tone")) { self.setFilter(CIFilter.sepiaTone()) },
                    .default(Text("Unsharp Mask")) { self.setFilter(CIFilter.unsharpMask()) },
                    .default(Text("Vignette")) { self.setFilter(CIFilter.vignette()) },
                    .cancel()
                ])
            }
        }
    }

    func loadImage() {
        guard let inputImage = inputImage else { return }

        let beginImage = CIImage(image: inputImage)
		
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }

    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
		
        if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey) }
        if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(filterIntensity * 200, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(filterIntensity * 10, forKey: kCIInputScaleKey) }

        guard let outputImage = currentFilter.outputImage else { return }

        if let coreImage = context.createCGImage(outputImage, from: outputImage.extent) {
            let image = UIImage(cgImage: coreImage)
			
			self.image = Image(uiImage: image)
            processedImage = image
        }
    }

    func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        loadImage()
    }
}

struct FilterViewPreview: PreviewProvider {
    static var previews: some View {
		FilterView()
    }
}
