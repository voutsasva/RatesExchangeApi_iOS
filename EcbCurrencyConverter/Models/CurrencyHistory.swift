//
//  CurrencyHistory.swift
//  EcbCurrencyConverter
//
//  Created by Vassilis Voutsas on 02/07/2018.
//  Copyright © 2018 Vassilis Voutsas. All rights reserved.
//

struct CurrencyHistory: Decodable {
    let symbol: String
    let description: String
    let rates: [CurrencyHistoryRate]
}

struct CurrencyHistoryRate: Decodable {
    let date: String
    let value: Double
}
