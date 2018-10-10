//
//  CurrenciesVC.swift
//  EcbCurrencyConverter
//
//  Created by Vassilis Voutsas on 31/07/2018.
//  Copyright © 2018 Vassilis Voutsas. All rights reserved.
//

import UIKit

class CurrenciesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Declarations
    // --------------------
    private let cellId = "CurrencyCell"
    private var currenciesData: [Currency]?
    internal var selectedCurrency = ConversionCurrencyData()
    
    // MARK: - IBOutlets
    // ----------------
    @IBOutlet weak var tblCurrencies: UITableView!
    
    // MARK: - Main methods
    // ------------------
    func getSupportedCurrencies() {
        let spinner = showLoader(view: self.view)
        ApiService.shared.fetchApiData(urlString: Routes.currenciesUri) { (currencies: [Currency]) in
            self.currenciesData = currencies
            self.tblCurrencies.reloadData()
            spinner.dismissLoader()
        }
    }
    
    // MARK: - Table View delegate methods
    // ---------------------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currenciesData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? CurrencyCell else { return UITableViewCell() }
        guard let data = currenciesData else { return cell }
        let currency = data[indexPath.row]
        cell.imgCurrency.image = UIImage(named: "\(currency.symbol.lowercased())")
        cell.lblCurrencyDescr.text = "\(currency.description) (\(currency.symbol))"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let _ = selectedCurrency.details else { return }
        selectedCurrency.currency = currenciesData?[indexPath.row]
        self.performSegue(withIdentifier: "unwindFromCurrenciesList", sender: self)
    }
    
    // MARK: - View Controller Lifecycle
    // ---------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Supported currencies"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        
        getSupportedCurrencies()
    }

}
