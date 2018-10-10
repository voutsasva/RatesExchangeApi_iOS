//
//  ConvertRate.swift
//  EcbCurrencyConverter
//
//  Created by Vassilis Voutsas on 28/06/2018.
//  Copyright © 2018 Vassilis Voutsas. All rights reserved.
//

import UIKit

class CurrencyDetailsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Declarations
    // --------------------
    var rate: RateDetail?
    private var currencyData: CurrencyHistory?
    private let cellId = "CurrencyHistoryCell"
    private let dataFromDate = "2000-01-01"

    // MARK: - IBOutlets
    // ----------------
    @IBOutlet weak var lblCurrencyDescr: UILabel!
    @IBOutlet weak var imgCurrency: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblLatestDate: UILabel!
    @IBOutlet weak var lblLatestRate: UILabel!
    @IBOutlet weak var lblMinDate: UILabel!
    @IBOutlet weak var lblMaxDate: UILabel!

    // MARK: - Main methods
    // ------------------
    func getCurrencyHistoryData(symbol currency: String) {
        let uri = "\(Routes.currencyHistoryRatesUri)&currency=\(currency)&from_date=\(dataFromDate)"
        fetchHistoryCurrencyData(uri)
    }

    func fetchHistoryCurrencyData(_ url: String) {
        let spinner = showLoader(view: self.view)
        ApiService.shared.fetchApiData(urlString: url) { (rates: CurrencyHistory) in
            self.currencyData = rates
            self.tableView.reloadData()
            guard let data = self.currencyData else {return}
            self.currencyDetails(rates: data.rates)
            spinner.dismissLoader()
        }
    }

    func currencyDetails(rates: [CurrencyHistoryRate]) {
        let minRate = rates.map { $0.value }.min() ?? 0
        let maxRate = rates.map { $0.value }.max() ?? 0
        let minHistoryRate = rates.filter { $0.value == minRate }.first!
        let maxHistoryRate = rates.filter { $0.value == maxRate }.first!
        let latestRate = rates.first!
        lblMinDate.text = "Minimum (\(minHistoryRate.date)): \(minHistoryRate.value)"
        lblMaxDate.text = "Maximum (\(maxHistoryRate.date)): \(maxHistoryRate.value)"
        lblLatestDate.text = "Latest: \(latestRate.date)"
        lblLatestRate.text = "EUR 1 = \(self.rate!.symbol) \(latestRate.value)"
    }

    // MARK: - Table View delegate methods
    // ---------------------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyData?.rates.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? CurrencyHistoryCell else { return UITableViewCell() }
        guard let data = currencyData?.rates else { return cell }
        let rateData = data[indexPath.row]
        cell.lblDate.text = rateData.date
        cell.lblAmount.text = String(rateData.value)
        return cell
    }

    // MARK: - View Controller Lifecycle
    // ---------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let rateData = rate else { return }
        imgCurrency.image = UIImage(named: "\(rateData.symbol.lowercased())")
        lblCurrencyDescr.text = rateData.currency
        
        navigationItem.title = "Rates of \(rateData.symbol)"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        
        getCurrencyHistoryData(symbol: rateData.symbol)
    }

}
