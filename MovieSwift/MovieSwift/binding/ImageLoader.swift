//
//  ImageData.swift
//  MovieSwift
//
//  Created by Thomas Ricouard on 09/06/2019.
//  Copyright © 2019 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import UIKit
import Combine

final class ImageLoader: BindableObject {
    let willChange = PassthroughSubject<UIImage?, Never>()
    
    let path: String?
    let size: ImageService.Size
    
    var image: UIImage? = nil
    var missing: Bool = false
    
    init(path: String?, size: ImageService.Size) {
        self.size = size
        self.path = path
    }
    
    func loadImage() {
        guard let poster = path else {
            willChange.send(nil)
            missing = true
            return
        }
        ImageService.shared.image(poster: poster, size: .medium) { [weak self] (result) in
            do {
                let result = try result.get()
                DispatchQueue.main.async {
                    self?.willChange.send(result)
                    self?.image = result
                }
            }
            catch { }
        }
    }
}
