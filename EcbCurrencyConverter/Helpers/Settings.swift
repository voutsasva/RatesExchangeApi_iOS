//
//  Settings.swift
//  EcbCurrencyConverter
//
//  Created by Vassilis Voutsas on 26/06/2018.
//  Copyright © 2018 Vassilis Voutsas. All rights reserved.
//

class GlobalSettings {
    static let shared = GlobalSettings()
    
    //Rates Exchange API key [YOUR_API_KEY]
    //Get your own api key from https://ratesexchange.eu
    let ratesExchangeApiKey = "[YOUR_API_KEY]"
    
    
}

struct Routes {
    private static let s = GlobalSettings.shared
    
    static let apiBaseUrl = "https://api.ratesexchange.eu/client"
    static let apiCheckOnLine = "\(apiBaseUrl)/checkapi"
    static let apiKeyParam = "?apiKey=\(s.ratesExchangeApiKey)"
    static let latestDetailedRatesUri = "\(apiBaseUrl)/latestdetails\(apiKeyParam)"
    static let currenciesUri = "\(apiBaseUrl)/currencies\(apiKeyParam)"
    static let convertRatesUri = "\(apiBaseUrl)/convertdetails\(apiKeyParam)"
    static let currencyHistoryRatesUri = "\(apiBaseUrl)/historydates\(apiKeyParam)"
    static let historyRatesForCurrency = "\(apiBaseUrl)/historydetails\(apiKeyParam)"
}
