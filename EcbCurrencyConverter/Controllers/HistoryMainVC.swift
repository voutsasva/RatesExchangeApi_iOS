//
//  HistoryMainVC.swift
//  EcbCurrencyConverter
//
//  Created by Vassilis Voutsas on 12/07/2018.
//  Copyright © 2018 Vassilis Voutsas. All rights reserved.
//

import UIKit

class HistoryMainVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Declarations
    // --------------------
    private let cellId = "CurrencyCell"
    private var currenciesData: [Currency]?
    private var pickerDate: String?

    // MARK: - IBOutlets
    // ----------------
    @IBOutlet weak var tblCurrencies: UITableView!
    @IBOutlet weak var datePickerRate: UIDatePicker!
    @IBOutlet weak var btnDisplayRates: UIButton!

    // MARK: - IBActions
    // ----------------
    @IBAction func btnDisplayRatesAction(_ sender: Any) {
        guard let _ = pickerDate else { return }
        self.performSegue(withIdentifier: "showHistory", sender: nil)
    }
    
    @IBAction func datePickerChanged(_ sender: Any) {
        pickerDate = getDateFromPicker()
    }

    // MARK: - Main methods
    // -------------------
    func getSupportedCurrencies() {
        let spinner = showLoader(view: self.view)
        btnDisplayRates.isEnabled = false
        ApiService.shared.fetchApiData(urlString: Routes.currenciesUri) { (currencies: [Currency]) in
            self.currenciesData = currencies
            self.tblCurrencies.reloadData()
            spinner.dismissLoader()
            self.btnDisplayRates.isEnabled = true
            self.pickerDate = self.getDateFromPicker()
        }
    }

    func getDateFromPicker() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let selectedDate = formatter.string(from: datePickerRate.date)
        print("Selected date: \(selectedDate)")
        return selectedDate
    }

    private func setupDatePicker() {
        let calendarDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        datePickerRate.setDate(calendarDate!, animated: true)
        datePickerRate.maximumDate = calendarDate
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
        if currency.symbol == "EUR" {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: UITableView.ScrollPosition.middle)
        }
        return cell
    }

    // MARK: - Segues
    // --------------
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showHistory" {
            if let vc = segue.destination as? HistoryDetailsVC {
                guard   let date = pickerDate,
                        let data = currenciesData,
                        let indexpath = tblCurrencies.indexPathForSelectedRow
                        else { return }
                vc.historyDate = date
                vc.currency = Currency(symbol: data[indexpath.row].symbol, description: data[indexpath.row].description)
            }
        }
    }

    // MARK: - View Controller Lifecycle
    // ---------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Historical"
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.prefersLargeTitles = false

        setupDatePicker()

        getSupportedCurrencies()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
