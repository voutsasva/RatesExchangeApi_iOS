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

    func fetchApiData<T: Decodable>(urlString: String, completion: @escaping (T?, ErrorModel?) -> ()) {
        guard let url = URL(string: urlString) else { return }
        print("*************")
        print("Endpoint url: \(url)")
        print("*************")
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let err = err {
                print("Failed to get data:", err)
                return
            }
            if let error = self.checkResponse(response: response, data: data) {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
            if let responseData: T = self.handleSuccess(data: data) {
                DispatchQueue.main.async {
                    completion(responseData, nil)
                }
            }
        }.resume()

    }

    func handleSuccess<T: Decodable>(data: Data?) -> T? {
        guard let data = data else { return nil }
        do {
            let responseModel = try JSONDecoder().decode(T.self, from: data)
            return responseModel
        } catch let jsonErr {
            print("Failed to serialize json:", jsonErr)
        }
        return nil
    }

    func checkResponse(response: URLResponse?, data: Data?) -> ErrorModel? {
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode != 200 {
                let error = self.errorHandle(httpResponse: httpResponse, data: data)
                return error
            }
        }
        return nil
    }

    func errorHandle(httpResponse: HTTPURLResponse, data: Data?) -> ErrorModel? {
        print("Status code: \(httpResponse.statusCode)")
        var error: ErrorModel?
        guard let data = data else { return nil }
        do {
            error = try JSONDecoder().decode(ErrorModel.self, from: data)
        }
        catch let jsonErr {
            print("Failed to serialize error in json:", jsonErr)
        }
        print("Error code : \(error?.Code ?? "")")
        print("Message : \(error?.Message ?? "")")
        return error
    }

}
