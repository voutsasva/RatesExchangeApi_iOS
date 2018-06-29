//
//  Settings.swift
//  EcbCurrencyConverter
//
//  Created by Vassilis Voutsas on 26/06/2018.
//  Copyright © 2018 Vassilis Voutsas. All rights reserved.
//

class GlobalSettings {
    static let shared = GlobalSettings()
    
    //Rates Exchange API key
    let ratesExchangeApiKey = ""
    
    
}

struct Routes {
    private static let s = GlobalSettings.shared
    
    static let apiBaseUrl = "https://api.ratesexchange.eu"
    static let latestDetailedRatesUri = "\(apiBaseUrl)/client/latestdetails?apiKey=\(s.ratesExchangeApiKey)"
    static let currenciesUri = "\(apiBaseUrl)/client/currencies?apiKey=\(s.ratesExchangeApiKey)"
    static let convertRatesUri = "\(apiBaseUrl)/client/convert?apiKey=\(s.ratesExchangeApiKey)"
}
