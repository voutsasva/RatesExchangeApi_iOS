//
//  UIActivityIndicatorView.swift
//  EcbCurrencyConverter
//
//  Created by Vassilis Voutsas on 12/07/2018.
//  Copyright © 2018 Vassilis Voutsas. All rights reserved.
//

import UIKit

extension UIActivityIndicatorView {

    func dismissLoader() {
        self.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }

}
