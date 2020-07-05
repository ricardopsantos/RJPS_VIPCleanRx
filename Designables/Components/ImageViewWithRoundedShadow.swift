//
//  ImageViewWithRoundedShadow.swift
//  Designables
//
//  Created by Ricardo Santos on 05/07/2020.
//  Copyright © 2020 Ricardo P Santos. All rights reserved.
//

import Foundation
import UIKit

open class ImageViewWithRoundedShadow: ViewWithRoundShadow {

    private var imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
     }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        addSubview(imageView)
        imageView.autoLayout.edgesToSuperview()
        imageView.addCorner(radius: Self.cornerRadius)
    }

    public var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
}
