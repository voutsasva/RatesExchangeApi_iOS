//
//  RatesTVC.swift
//  EcbCurrencyConverter
//
//  Created by Vassilis Voutsas on 26/06/2018.
//  Copyright © 2018 Vassilis Voutsas. All rights reserved.
//

import UIKit

class RatesTVC: UITableViewController {
    
    var allRates: RatesModel?
    let cellId = "cellRate"
    
    
    @IBOutlet weak var lblCurrenciesDate: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchRatesData(Routes.latestDetailedRatesUri)
        
        navigationItem.title = "ECB Rates"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func fetchRatesData(_ url: String) {
        ApiService.shared.fetchApiData(urlString: url) { (rates: RatesModel) in
            self.allRates = rates
            self.tableView.reloadData()
            self.lblCurrenciesDate.text = "Last update date: \(self.allRates!.date)"
        }
    }
    

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allRates?.rates.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! RateCell
        guard let data = allRates?.rates else { return cell }
        let rateData = data[indexPath.row]
        cell.lblCurrencyDescr.text = rateData.currency
        cell.lblCurrencyIso.text = rateData.symbol
        cell.lblAmount.text = String(rateData.value)
        cell.imgCurrency.image = UIImage(named: "\(rateData.symbol.lowercased())")

        return cell
    }
 

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showConvert" {
            if let vc = segue.destination as? CurrencyHistoryVC {
                let indexpath = tableView.indexPathForSelectedRow
                vc.rate = allRates?.rates[(indexpath?.row)!]
            }
        }
    }
    

}
