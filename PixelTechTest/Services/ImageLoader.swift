//
//  ImageLoader.swift
//  PixelTechTest
//
//  Created by Phil Margetson on 18/01/2026.
//

import UIKit

class ImageLoader {
    
    static let shared = ImageLoader()
    private let imageCache = NSCache<NSString, UIImage>() //cache using image url as key
    
    func loadImage(imageURL: URL) async -> UIImage? {
        
        // return image from cache if already have it
        if let cachedImage = imageCache.object(forKey: imageURL.absoluteString as NSString) {
            return cachedImage
        }
        
        //fetch from network if not in cache
        do {
            let (data, _) = try await URLSession.shared.data(from: imageURL)
            guard let image = UIImage(data: data) else { return nil }
            imageCache.setObject(image, forKey: imageURL.absoluteString as NSString)
            return image
        } catch {
            return nil
        }
    }
}
