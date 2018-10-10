//
//  MainVC.swift
//  EcbCurrencyConverter
//
//  Created by Vassilis Voutsas on 02/07/2018.
//  Copyright © 2018 Vassilis Voutsas. All rights reserved.
//

import UIKit

class MainVC: UIViewController {

    // MARK: - IBOutlets
    // -----------------
    @IBOutlet weak var imgStatus: UIImageView!
    @IBOutlet weak var statusIndicator: UIActivityIndicatorView!

    // MARK: - Main methods
    // ------------------
    func checkIfApiIsOnLine() {
        imgStatus.image = nil
        statusIndicator.startAnimating()
        let url = Routes.apiCheckOnLine
        ApiService.shared.fetchApiData(urlString: url) { (response: ResultModel) in
            print("API is online: \(response.result)")
            self.imgStatus.image = response.result ? #imageLiteral(resourceName: "online") : #imageLiteral(resourceName: "offline")
            self.statusIndicator.stopAnimating()
        }
    }

    // MARK: - View Controller Lifecycle
    // ---------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Currencies"
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.prefersLargeTitles = false
        checkIfApiIsOnLine()
    }

}
