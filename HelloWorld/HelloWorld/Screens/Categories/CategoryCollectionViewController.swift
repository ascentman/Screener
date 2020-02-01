//
//  CategoryCollectionViewController.swift
//  HelloWorld
//
//  Created by Volodymyr Rykhva on 2/1/20.
//  Copyright © 2020 Tao Xu. All rights reserved.
//

import UIKit

private let reuseIdentifier = "categoryCell"

final class CategoryCollectionViewController: UICollectionViewController {

    private lazy var module: TorchModule = {
        if let filePath = Bundle.main.path(forResource: "model", ofType: "pt"),
            let module = TorchModule(fileAtPath: filePath) {
            return module
        } else {
            fatalError("Can't find the model file!")
        }
    }()

    private lazy var labels: [String] = {
        if let filePath = Bundle.main.path(forResource: "words", ofType: "txt"),
            let labels = try? String(contentsOfFile: filePath) {
            return labels.components(separatedBy: .newlines)
        } else {
            fatalError("Can't find the text file!")
        }
    }()

    private var imagesArray: [UIImage] = []
    private var titlesArray: [String] = []
    private let photoManager = PhotoManager()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.delegate = self

        imagesArray = photoManager.grabScreentshots()

        for image in imagesArray {
            let resizedImage = image.resized(to: CGSize(width: 32, height: 32))
            guard var pixelBuffer = resizedImage.normalized() else { return }
            guard let outputs = module.predict(image: UnsafeMutableRawPointer(&pixelBuffer)) else { return }
            let zippedResults = zip(labels.indices, outputs)
            let sortedResults = zippedResults.sorted { $0.1.floatValue > $1.1.floatValue }.prefix(3)
            var text = ""
            for result in sortedResults {
                text += "\u{2022} \(labels[result.0]) \n\n"
            }
            titlesArray.append(text)
        }
    }

    // MARK: - UICollectionViewDelegate & UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imagesArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ImageCollectionViewCell
        cell?.setupCell(image: imagesArray[indexPath.row], title: titlesArray[indexPath.row])
        return cell ?? UICollectionViewCell()
    }
}

// MARK: - Extensions

extension CategoryCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 10
        let collectionViewSize = collectionView.frame.size.width - padding

        return CGSize(width: collectionViewSize / 2, height: collectionViewSize / 2)
    }
}
