//
//  ConvertRate.swift
//  EcbCurrencyConverter
//
//  Created by Vassilis Voutsas on 28/06/2018.
//  Copyright © 2018 Vassilis Voutsas. All rights reserved.
//

import UIKit


class ConvertRate: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    //MARK: - Declarations
    var rate: Rate?
    var currencyData: CurrencyHistory?
    let cellId = "CurrencyHistoryCell"
    
    //MARK: - IBOutlets
    @IBOutlet weak var lblCurrencyDescr: UILabel!
    @IBOutlet weak var imgCurrency: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    
    
    //MARK: Main methods
    func getCurrencyHistoryData(symbol currency: String) {
        let uri = "\(Routes.currencyHistoryRatesUri)&currency=\(currency)&from_date=2018-01-01"
        fetchHistoryCurrencyData(uri)
    }
    
    func fetchHistoryCurrencyData(_ url: String) {
        ApiService.shared.fetchApiData(urlString: url) { (rates: CurrencyHistory) in
            self.currencyData = rates
            self.tableView.reloadData()
        }
    }
    
    
    
    
    //MARK: Table methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyData?.rates.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! CurrencyHistoryCell
        guard let data = currencyData?.rates else { return cell }
        let rateData = data[indexPath.row]
        cell.lblDate.text = rateData.date
        cell.lblAmount.text = String(rateData.value)
        
        return cell
    }
    
    
    
    
    //MARK: -
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
