//
//  PhotoManager.swift
//  HelloWorld
//
//  Created by Volodymyr Rykhva on 2/1/20.
//  Copyright © 2020 Tao Xu. All rights reserved.
//

import UIKit
import Photos

final class PhotoManager {

    private var imageArray: [UIImage] = []

    func grabScreentshots() -> [UIImage] {
        let manager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat

        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

        let albumsPhoto:PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)

        albumsPhoto.enumerateObjects({(collection, index, object) in
            if collection.localizedTitle == "Screenshots" {
                let photoInAlbum = PHAsset.fetchAssets(in: collection, options: nil)
                if photoInAlbum.count > 0 {
                    for i in 0..<photoInAlbum.count {
                        manager.requestImage(for: photoInAlbum.object(at: i),
                                             targetSize: CGSize(width: 200, height: 200),
                                             contentMode: .aspectFill,
                                             options: requestOptions) { image, error in
                                                if let image = image {
                                                    self.imageArray.append(image)
                                                } else {
                                                    debugPrint("[DEBUG]: can't get image from PHAsset")
                                                }
                        }
                    }
                } else {
                    debugPrint("[DEBUG]: no screenshots on iphone")
                }
            }
        })

        return imageArray
    }
}
