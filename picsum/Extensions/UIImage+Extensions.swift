//
//  UIImage.swift
//  picsum
//
//  Created by Tieu Viet Trong Nghia on 26/8/24.
//

import Foundation
import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    func loadImageUsingCache(withUrl urlString: String) {
        // Set default image when loading image from network
        self.image = UIImage(systemName: "photo")
        
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            DispatchQueue.main.async {
                self.image = cachedImage
            }
            return
        }   
        
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error loading image: \(error.localizedDescription)")
                return
            }
            
            if let data = data, let downloadedImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    let scaledImage = self.scaleImage(downloadedImage, to: self.frame.size)
                    imageCache.setObject(scaledImage, forKey: urlString as NSString)
                    self.image = scaledImage
                }
            }
        }.resume()
    }
    
    // Optimize image to prevent lagging
    private func scaleImage(_ image: UIImage, to size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        image.draw(in: CGRect(origin: .zero, size: size))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage!
    }
}
