//
//  ImageCollectionViewCell.swift
//  HelloWorld
//
//  Created by Volodymyr Rykhva on 2/1/20.
//  Copyright © 2020 Tao Xu. All rights reserved.
//

import UIKit

final class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()

        imageView.image = nil
        titleLabel.text = nil
    }

    func setupCell(image: UIImage, title: String) {
        imageView.image = image
        titleLabel.text = title
    }
}
