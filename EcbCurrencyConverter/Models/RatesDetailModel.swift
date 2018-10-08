//
//  RatesModel.swift
//  EcbCurrencyConverter
//
//  Created by Vassilis Voutsas on 26/06/2018.
//  Copyright © 2018 Vassilis Voutsas. All rights reserved.
//

struct RatesDetailModel: Decodable {
    let base: String
    let date: String
    let rates: [RateDetail]
}

struct RateDetail: Decodable {
    let symbol: String
    let currency: String
    let value: Double
}
