//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinServiceDelegate {
    func didGetRate(_ coinManager: CoinManager, data: Coin)
    func didFailWithError(_ coinManager: CoinManager, error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "<API-KEY-HERE>"
    var delegate: CoinServiceDelegate?
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func getCoinPrice(for currency: String) {
        let url = URL(string: "\(baseURL)/\(currency)")
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = ["X-CoinAPI-Key": apiKey]
        let urlSession = URLSession(configuration: configuration)
        if let safeUrl = url {
            urlSession.dataTask(with: safeUrl) { data, response, error in
                if (error != nil) {
                    delegate?.didFailWithError(self, error: error!)
                }
                if let safeData = data, let coin = parseData(safeData) {
                    delegate?.didGetRate(self, data: coin)
                }
            }.resume()
        }
    }

    private func parseData(_ data: Data) -> Coin? {
        do {
            let parsedData = try JSONDecoder().decode(CoinData.self, from: data)
            return Coin(time: parsedData.time, asset_id_base: parsedData.asset_id_base, asset_id_quote: parsedData.asset_id_quote, rate: parsedData.rate)
        } catch {
            delegate?.didFailWithError(self, error: error)
            return nil
        }

    }
}
