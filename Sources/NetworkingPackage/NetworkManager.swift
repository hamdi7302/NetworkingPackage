//
//  File.swift
//  
//
//  Created by hamdi on 23/9/2024.
//

import Foundation


enum Authmethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}


protocol NetworkService {
    func request<T:Decodable>(endoint: String, authmethod: Authmethod, headers:[String:String]?, params: [String:String]?) -> AnyPublisher<T, NetworkError>
}

struct NetworkManager: NetworkService {
    func request<T>(endoint: String, authmethod: Authmethod = .get, headers:[String:String]? = nil, params: [String:String]? = nil) -> AnyPublisher<T, NetworkError> where T : Decodable {
        
        guard let url =  URL(string: endoint) else {
            return Fail(error: NetworkError.unvalidUrl).eraseToAnyPublisher()
        }
        
        var urlReq = URLRequest(url: url,timeoutInterval: 25)
        urlReq.httpMethod = authmethod.rawValue
        if let headers = headers {
            headers.forEach { (key: String, value: String) in
                urlReq.addValue(value, forHTTPHeaderField: key)
            }
        }
        
      
        if let dictParams =  params , let jsonParams = try?  JSONSerialization.data(withJSONObject: dictParams, options: []){
            urlReq.httpBody = jsonParams
        }
        
        let res = URLSession.shared.dataTaskPublisher(for: urlReq)
            .handleEvents(receiveOutput: { output in
                // Print the HTTP response
                if let httpResponse = output.response as? HTTPURLResponse {
                    print("Response Status Code: \(httpResponse.statusCode)")
                    print("Response Headers: \(httpResponse.allHeaderFields)")
                }
            })
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                return   error is DecodingError ? NetworkError.decodableError : NetworkError.unkownError
            }.eraseToAnyPublisher()
        
        return res
    }
}

