//
//  ConverterVC.swift
//  EcbCurrencyConverter
//
//  Created by Vassilis Voutsas on 07/08/2018.
//  Copyright © 2018 Vassilis Voutsas. All rights reserved.
//

import UIKit

struct ConversionData {
    var fromCurrency: String?
    var toCurrency: String?
    var convertDate: String?
    var fromAmount: Double?
    
    
}

class ConverterVC: UIViewController {

    //MARK: - Declarations
    // --------------------
//    private var fromCurrency: String?
//    private var toCurrency: String?
//    private var latestDate: String?
//    private var fromAmount: Double = 0
    private var conversionData = ConversionData()
    
    
    //MARK: - IBOutlets
    // ----------------
    @IBOutlet weak var lblLastUpdate: UILabel!
    @IBOutlet weak var imgLeftCurrency: UIImageView!
    @IBOutlet weak var lblLeftCurrency: UILabel!
    @IBOutlet weak var imgRightCurrency: UIImageView!
    @IBOutlet weak var lblRightCurrency: UILabel!
    @IBOutlet weak var txtLeftInput: UITextField!
    @IBOutlet weak var txtRightInput: UITextField!
    
    
    
    //MARK: - IBActions
    // ----------------
    @IBAction func btnReplaceAction(_ sender: Any) {
    }
    
    @IBAction func btnEqualAction(_ sender: Any) {
        
        getConversionData()
    }
    
    
    
    //MARK: - Main methods
    // ------------------
    func initialData() {
        txtLeftInput.text = "1"
        //let spinner = showLoader(view: self.view)
        //DispatchQueue.main.async {
            self.getApiEcbLatestDate(completion: { (date: String?) in
                guard let getDate = date else { return }
                self.conversionData.convertDate = getDate
                self.lblLastUpdate.text = "Last update date: \(getDate)"
            })
            //spinner.dismissLoader()
        //}
    }
    
    func getApiEcbLatestDate(completion: @escaping (String?) -> Void) {
        var date: String?
        ApiService.shared.fetchApiData(urlString: Routes.latestDetailedRatesUri) { (rates: RatesDetailModel) in
            date = rates.date
            completion(date)
        }
    }
    
    func getConversionData() {
        guard let amount = txtLeftInput.text, let fromCur = lblLeftCurrency.text, let toCur = lblRightCurrency.text else { return }
        
        conversionData.fromAmount = Double(amount)!
        conversionData.fromCurrency = fromCur
        conversionData.toCurrency = toCur
    }
    
    
    
    
    
    //MARK: - View Controller Lifecycle
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
