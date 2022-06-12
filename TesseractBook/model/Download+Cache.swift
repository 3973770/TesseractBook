//
//  images.swift
//  TesseractBook
//
//  Created by Kostiantyn Bohonos on 6/11/22.
//

import Foundation
import UIKit

enum imgSize:String{
    case small = "small"
    case big = "big"
}


// Store all images in cache directory
class ThumbnailCache{
    static func GetUrl(by id:String,size iSize:imgSize) -> URL {
        var PathtoFile = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        PathtoFile = PathtoFile.appendingPathComponent("\(id)_\(iSize.rawValue)")
        PathtoFile = PathtoFile.appendingPathExtension("png")
        return PathtoFile
    }
    
    static func GetImageThumbnail(by id:String,size iSize:imgSize) -> UIImage? {
        return UIImage(contentsOfFile: GetUrl(by: id, size: iSize).path)
    }
    
    static func UpdateImageThumbnail(by id:String,size iSize:imgSize,with data:Data){
        try? data.write(to: GetUrl(by: id, size: iSize))
    }
}


extension UIImageView {
    
    // function set image for ImageView
    /// if present in cache - load image from file
    /// if not present - download from url and save to cache
    func load(_ b: book,size iSize:imgSize) {
        guard let stringurl = b.volumeInfo.imageLinks?.smallThumbnail else {
            return
        }
        
        if let imagecache = ThumbnailCache.GetImageThumbnail(by: b.id, size: iSize) {
            DispatchQueue.main.async {
                self.image = imagecache
            }
        }else{
            DispatchQueue.global().async { [weak self] in
                if let url = URL(string: stringurl) {
                    if let data = try? Data(contentsOf: url) {
                        ThumbnailCache.UpdateImageThumbnail(by: b.id, size: iSize, with: data)
                        if let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                self?.image = image
                            }
                        }
                    }
                }
            }
        }
    }
    
}
