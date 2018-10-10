//
//  ApiHandler.swift
//  EcbCurrencyConverter
//
//  Created by Vassilis Voutsas on 26/06/2018.
//  Copyright © 2018 Vassilis Voutsas. All rights reserved.
//

import Foundation

struct ApiService {

    static let shared = ApiService()

    func fetchApiData<T: Decodable>(urlString: String, completion: @escaping (T) -> ()) {
        guard let url = URL(string: urlString) else { return }
        print("*************")
        print("Endpoint url: \(url)")
        print("*************")
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let err = err {
                print("Failed to get data:", err)
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    self.errorHandle(httpResponse: httpResponse, data: data)
                    return
                }
            }
            guard let data = data else { return }
            do {
                let responseModel = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(responseModel)
                }
            } catch let jsonErr {
                print("Failed to serialize json:", jsonErr)
            }

        }.resume()

    }

    func errorHandle(httpResponse: HTTPURLResponse, data: Data?) {
        print("Status code: \(httpResponse.statusCode)")
        do {
            guard let data = data else { return }
            let jsonDecoder = JSONDecoder()
            let error = try jsonDecoder.decode(ErrorModel.self, from: data)
            print("Error code : \(error.Code ?? "")")
            print("Message : \(error.Message ?? "")")
        }
        catch {
        }
    }

}
