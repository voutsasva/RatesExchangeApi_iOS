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
    private var selectedCurrency: ConversionCurrencyData?
    private var selectedConversionDetails = ConversionDetails()

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

    @IBAction func btnFromAction(_ sender: Any) {
        selectedConversionDetails.amount = txtLeftInput.text
        selectedConversionDetails.source = "left"
        self.performSegue(withIdentifier: "currencies", sender: self)
    }
    
    @IBAction func btnToAction(_ sender: Any) {
        selectedConversionDetails.amount = txtRightInput.text
        selectedConversionDetails.source = "right"
        self.performSegue(withIdentifier: "currencies", sender: self)
    }
    
    
    // MARK: - Main methods
    // ------------------
    func initialData() {
        setFromCurrencyData(img: UIImage(named: "eur"), curIso: "EUR", amount: "1.0")
        setToCurrencyData(img: UIImage(named: "usd"), curIso: "USD", amount: "0.0")
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

    func getConversionData() -> ConversionData? {
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

    func setFromCurrencyData(img: UIImage?, curIso: String, amount: String) {
        imgLeftCurrency.image = img
        lblLeftCurrency.text = curIso
        txtLeftInput.text = amount
    }

    func setToCurrencyData(img: UIImage?, curIso: String, amount: String) {
        imgRightCurrency.image = img
        lblRightCurrency.text = curIso
        txtRightInput.text = amount
    }
    
    func getApiEcbConvertRates(data: ConversionData) {
        let spinner = showLoader(view: self.view)
        let callUri = createConvertRatesUri(fromCur: data.fromCurrency!, date: data.convertDate!, amount: data.fromAmount!, toCur: data.toCurrency!)
        DispatchQueue.main.async {
            ApiService.shared.fetchApiData(urlString: callUri) { (rates: RatesDetailModel) in
                if !rates.rates.isEmpty {
                    let amount = rates.rates[0].value
                    self.txtRightInput.text = "\(amount)"
                }
                spinner.dismissLoader()
            }
        }
    }

    func createConvertRatesUri(fromCur: String, date: String, amount: Double, toCur: String) -> String {
        return "\(Routes.convertRatesUri)&from=\(fromCur)&amount=\(amount)&date=\(date)&currencies=\(toCur)"
    }

    // MARK: - Navigation
    // ------------------
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "currencies" {
            guard let currenciesVC = segue.destination as? CurrenciesVC else {return}
            currenciesVC.selectedCurrency.details = self.selectedConversionDetails
        }
    }

    @IBAction func unwindFromCurrenciesList(_ segue: UIStoryboardSegue) {
        if let currenciesVC = segue.source as? CurrenciesVC {
            let data = currenciesVC.selectedCurrency
            guard let source = data.details?.source, let amount = data.details?.amount, let currency = data.currency else { return }
            if source == "left" {
                setFromCurrencyData(img: UIImage(named: currency.symbol.lowercased()), curIso: currency.symbol, amount: amount)
            } else {
                setToCurrencyData(img: UIImage(named: currency.symbol.lowercased()), curIso: currency.symbol, amount: amount)
            }
        }
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
