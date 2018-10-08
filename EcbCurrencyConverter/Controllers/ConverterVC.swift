//
//  ConverterVC.swift
//  EcbCurrencyConverter
//
//  Created by Vassilis Voutsas on 07/08/2018.
//  Copyright © 2018 Vassilis Voutsas. All rights reserved.
//

import UIKit

class ConverterVC: UIViewController {

    // MARK: - Declarations
    // --------------------
    private var currentRatesDate: String?
    
    // MARK: - IBOutlets
    // ----------------
    @IBOutlet weak var lblLastUpdate: UILabel!
    @IBOutlet weak var imgLeftCurrency: UIImageView!
    @IBOutlet weak var lblLeftCurrency: UILabel!
    @IBOutlet weak var imgRightCurrency: UIImageView!
    @IBOutlet weak var lblRightCurrency: UILabel!
    @IBOutlet weak var txtLeftInput: UITextField!
    @IBOutlet weak var txtRightInput: UITextField!
    
    
    
    // MARK: - IBActions
    // ----------------
    @IBAction func btnReplaceAction(_ sender: Any) {
        revertCurrencies(mainImg: imgLeftCurrency.image, mainCur: lblLeftCurrency.text, mainAmt: txtLeftInput.text)
    }
    
    @IBAction func btnEqualAction(_ sender: Any) {
        
        guard let conversionData = getConversionData() else {return}
        getApiEcbConvertRates(data: conversionData)
    }
    
    
    
    // MARK: - Main methods
    // ------------------
    func initialData() {
        txtLeftInput.text = "1"
        let spinner = showLoader(view: self.view)
        DispatchQueue.main.async {
            self.getApiEcbLatestDate(completion: { (date: String?) in
                guard let getDate = date else { return }
                self.currentRatesDate = getDate
                self.lblLastUpdate.text = "Rates based on: \(self.currentRatesDate!)"
                spinner.dismissLoader()
            })
        }
    }
    
    func getApiEcbLatestDate(completion: @escaping (String?) -> Void) {
        var date: String?
        ApiService.shared.fetchApiData(urlString: Routes.latestDetailedRatesUri) { (rates: RatesDetailModel) in
            date = rates.date
            completion(date)
        }
    }
    
    func getConversionData()-> ConversionData? {
        guard
            let amount = txtLeftInput.text,
            let fromCur = lblLeftCurrency.text,
            let toCur = lblRightCurrency.text,
            let date = currentRatesDate
            else { return nil }
        let conversionData = ConversionData(fromCurrency: fromCur,
                                            toCurrency: toCur,
                                            convertDate: date,
                                            fromAmount: Double(amount.replacingOccurrences(of: ",", with: ".")) ?? 0.0)
        return conversionData
    }
    
    func revertCurrencies(mainImg: UIImage?, mainCur: String?, mainAmt: String?) {
        imgLeftCurrency.image = imgRightCurrency.image
        lblLeftCurrency.text = lblRightCurrency.text
        txtLeftInput.text = txtRightInput.text
        imgRightCurrency.image = mainImg
        lblRightCurrency.text = mainCur
        txtRightInput.text = mainAmt
    }
    
    func getApiEcbConvertRates(data: ConversionData) {
        let spinner = showLoader(view: self.view)
        let callUri = createConvertRatesUri(fromCur: data.fromCurrency!, date: data.convertDate!, amount: data.fromAmount!, toCur: data.toCurrency!)
        DispatchQueue.main.async {
            ApiService.shared.fetchApiData(urlString: callUri) { (rates: RatesDetailModel) in
                let amount = rates.rates[0].value
                self.txtRightInput.text = "\(amount)"
                spinner.dismissLoader()
            }
        }
    }
    
    func createConvertRatesUri(fromCur: String, date: String, amount: Double, toCur: String) -> String {
        return "\(Routes.convertRatesUri)&from=\(fromCur)&amount=\(amount)&date=\(date)&currencies=\(toCur)"
    }
    
    
    
    // MARK: - View Controller Lifecycle
    // ---------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Convert"
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.prefersLargeTitles = false
        
        initialData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
