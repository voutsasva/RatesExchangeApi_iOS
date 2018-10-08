//
//  CommonMethods.swift
//  EcbCurrencyConverter
//
//  Created by Vassilis Voutsas on 12/07/2018.
//  Copyright © 2018 Vassilis Voutsas. All rights reserved.
//

import UIKit

func showLoader(view: UIView) -> UIActivityIndicatorView {
    let spinner = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height:40))
    spinner.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    spinner.layer.cornerRadius = 3.0
    spinner.clipsToBounds = true
    spinner.hidesWhenStopped = true
    spinner.style = UIActivityIndicatorView.Style.white
    spinner.center = view.center
    view.addSubview(spinner)
    spinner.startAnimating()
    UIApplication.shared.beginIgnoringInteractionEvents()
    return spinner
}
