//
//  ConvertRate.swift
//  EcbCurrencyConverter
//
//  Created by Vassilis Voutsas on 28/06/2018.
//  Copyright © 2018 Vassilis Voutsas. All rights reserved.
//

import UIKit

protocol ConvertViewDelegate {
    func setRateValue(_ inputValue: String, inputSymbol: String)
}

class ConvertRate: UIViewController {

    //MARK: - Declarations
    var delegate: ConvertViewDelegate?
    var rate: Rate?
    
    
    //MARK: - IBOutlets
    @IBOutlet weak var lblCurrencyDescr: UILabel!
    @IBOutlet weak var imgCurrency: UIImageView!
    @IBOutlet weak var txtAmount: UITextField!
    
    
    //MARK: - IBActions
    @IBAction func btnGetRatesAction(_ sender: Any) {
        
        guard let value = txtAmount.text, let rateData = rate else { return }
        delegate?.setRateValue(value, inputSymbol: rateData.symbol)
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let rateData = rate else { return }
        imgCurrency.image = UIImage(named: "\(rateData.symbol.lowercased())")
        lblCurrencyDescr.text = rateData.currency
    }


}
