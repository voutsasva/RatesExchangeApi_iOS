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
    let ratesExchangeApiKey = "b1b744ca-3caf-48dc-9e32-d7df3ffb1f59"
    
    
}

struct Routes {
    private static let s = GlobalSettings.shared
    
    static let apiBaseUrl = "https://api.ratesexchange.eu"
    static let apiKeyParam = "?apiKey=\(s.ratesExchangeApiKey)"
    static let latestDetailedRatesUri = "\(apiBaseUrl)/client/latestdetails\(apiKeyParam)"
    static let currenciesUri = "\(apiBaseUrl)/client/currencies\(apiKeyParam)"
    static let convertRatesUri = "\(apiBaseUrl)/client/convert\(apiKeyParam)"
    static let currencyHistoryRatesUri = "\(apiBaseUrl)/client/historydates\(apiKeyParam)"
}
