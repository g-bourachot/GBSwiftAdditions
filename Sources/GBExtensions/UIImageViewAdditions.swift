//
//  UIImageViewAdditions.swift
//  
//
//  Created by Guillaume Bourachot on 12/12/2021.
//

import Foundation
#if canImport(UIKit)
import UIKit
import GBComponents

extension UIImageView {
    public func downloadedFrom(url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        let downloadingImageURL = url
        self.contentMode = mode
        if let image = GBCacheWorker.shared.getCachedObject(for: downloadingImageURL.absoluteString as NSString) as? UIImage {
            DispatchQueue.main.async() {
                if downloadingImageURL == url {
                    self.image = image
                }
             }
            return
        }
        if self.bounds.size.width < 10,
            let endIndex = downloadingImageURL.absoluteString.index(of: "_w") {
            let otherCachedImageKey = String(downloadingImageURL.absoluteString.prefix(upTo: endIndex))
            if let image = GBCacheWorker.shared.getCachedObject(for: otherCachedImageKey as NSString) as? UIImage {
                DispatchQueue.main.async() {
                    if downloadingImageURL == url {
                        self.image = image
                    }
                 }
                return
            }
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else {
                return
            }
            DispatchQueue.main.async() {
                GBCacheWorker.shared.saveCache(object: image, for: downloadingImageURL.absoluteString as NSString)
                GBCacheWorker.shared.saveCache(object: image, for: url.absoluteString as NSString)
                if downloadingImageURL == url {
                    self.image = image
                }
            }
        }.resume()
    }
    public func downloadedFrom(link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}
#endif
