//
//  SVProgressHUDExtension.swift
//  test
//
//  Created by PENA SANCHEZ Edwin Jose
//

import RxCocoa
import RxSwift
import SVProgressHUD
import UIKit

extension Reactive where Base: SVProgressHUD {
    public static var isAnimating: Binder<Bool> {
        return Binder(UIApplication.shared) { _, isVisible in
            if isVisible {
                SVProgressHUD.show()
            } else {
                SVProgressHUD.dismiss()
            }
        }
    }
}
