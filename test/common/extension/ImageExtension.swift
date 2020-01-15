//
//  ImageExtension.swift
//  test
//
//  Created by PENA SANCHEZ Edwin Jose on 15/01/2020.
//  Copyright © 2020 safe365. All rights reserved.
//

import UIKit

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
