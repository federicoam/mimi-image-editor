//
//  ImageSaver.swift
//  Mimi Image Editor
//
//  Created by Federico Maza on 26/09/2020.
//  Copyright © 2020 Federico Maza. All rights reserved.
//

import UIKit

class ImageSaver: NSObject {
    var successHandler: (() -> Void)?
    var errorHandler: ((Error) -> Void)?

    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(
			image,
			self,
			#selector(saveError),
			nil
		)
    }

    @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            errorHandler?(error)
        } else {
            successHandler?()
        }
    }
}
