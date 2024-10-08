//
//  NetworkManager.swift
//
//
//  Created by hamdi on 23/9/2024.
//

import Foundation
import Combine
import UIKit

public enum NetworkError: Error {
    case decodableError
    case networkError
    case unkownError
    case unvalidUrl
    case notimplementedyet
    case unableTofetchImage
}


protocol NetworkService {
    func request<T:Decodable>(endoint: String, authmethod: Authmethod, headers:[String:String]?, params: [String:Any]?) -> AnyPublisher<T, NetworkError>
}

public struct NetworkManager: NetworkService {
    public init(){}
  
     public func request<T>(endoint: String, authmethod: Authmethod = .get, headers:[String:String]? = nil, params: [String:Any]? = nil) -> AnyPublisher<T, NetworkError> where T : Decodable {
        
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
         
         
            // temp to test sometine api key in some service not  permitted ny tmdb
//            urlReq.setValue("application/json", forHTTPHeaderField: "Accept")
//            urlReq.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlReq.setValue("Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyNGE4OGEyMWFiN2MzNTE1ZTUwN2Q5ZWE2NGQ4ZDg3OCIsIm5iZiI6MTcyNzgyMzkxMC4wNzQ5OTEsInN1YiI6IjVlNTkxNDAyYTkzZDI1MDAxNzU1NjhkMSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.KITBRr1iAThYItOQE7CMxykQ-4FQI22L_H9jIqZ9TTQ", forHTTPHeaderField: "Authorization") // Temoparly
       

      
        if let dictParams =  params , let jsonParams = try?  JSONSerialization.data(withJSONObject: dictParams, options: []){
            urlReq.httpBody = jsonParams
        }
        
        let res = URLSession.shared.dataTaskPublisher(for: urlReq)
            .handleEvents(receiveOutput: { output in
                // Print the HTTP response
                if let httpResponse = output.response as? HTTPURLResponse {
                    print("⚠️❗ Response Status Code: \(httpResponse.statusCode)")
                    print("⚠️❗ Response Headers: \(httpResponse.allHeaderFields)")
                }
            })
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
         
            .mapError { error in
                         if let decodingError = error as? DecodingError {
                             print("Decoding Error: \(decodingError)")
                             switch decodingError {
                             case .dataCorrupted(let context):
                                 print("Data corrupted: \(context.debugDescription)")
                             case .keyNotFound(let key, let context):
                                 print("Key '\(key)' not found: \(context.debugDescription), codingPath: \(context.codingPath)")
                             case .typeMismatch(let type, let context):
                                 print("Type '\(type)' mismatch: \(context.debugDescription), codingPath: \(context.codingPath)")
                             case .valueNotFound(let value, let context):
                                 print("Value '\(value)' not found: \(context.debugDescription), codingPath: \(context.codingPath)")
                             @unknown default:
                                 print("Unknown decoding error")
                             }

                             return NetworkError.decodableError
                         }
                         print("Network/Other Error: \(error)")
                         return NetworkError.unkownError
                     }
         
//            .mapError { error in
//                return   error is DecodingError ? NetworkError.decodableError : NetworkError.unkownError
//            }
            .eraseToAnyPublisher()
        
        return res
    }
    
    public func fetchAndCacheImage (endoint: String, authmethod: Authmethod = .get, headers:[String:String]? = nil) -> AnyPublisher<UIImage?, NetworkError> {
        
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
        
        if let cachedUrlData = URLCache.shared.cachedResponse(for: urlReq),
           let image =  UIImage(data: cachedUrlData.data) {
            return Just(image)
                .setFailureType(to: NetworkError.self)
                .eraseToAnyPublisher()
        }
        
        urlReq.addValue("text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8", forHTTPHeaderField: "Accept")
        
        let res = URLSession.shared.dataTaskPublisher(for: urlReq)
            .handleEvents(receiveOutput: { output in
                // Print the HTTP response
                if let httpResponse = output.response as? HTTPURLResponse {
                    print("Response Status Code: \(httpResponse.statusCode)")
                    print("Response Headers: \(httpResponse.allHeaderFields)")
                }
                if let _ = output.data as Data?  {
                    let cached = CachedURLResponse(response: output.response, data: output.data)
                    URLCache.shared.storeCachedResponse(cached, for: urlReq)
                }
            })
            .map({ output in
                UIImage(data: output.data)
            })
            .mapError { error in
                print("error in fetchig Image ... \(error)" )
                return NetworkError.unkownError
            }.eraseToAnyPublisher()
        
        return res
    }
}



//
//
//import Combine
//import UIKit
//
//struct ImageLoaderPublisher: Publisher {
//    typealias Output = UIImage
//    typealias Failure = Error
//
//    let url: URL
//
//    func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
//        // Create a subscription instance and pass it to the subscriber
//        let subscription = ImageLoaderSubscription(subscriber: subscriber, url: url)
//        subscriber.receive(subscription: subscription)
//    }
//}
//
//final class ImageLoaderSubscription<S: Subscriber>: Subscription where S.Input == UIImage, S.Failure == Error {
//    
//    private var subscriber: S?
//    private let url: URL
//    
//    init(subscriber: S, url: URL) {
//        self.subscriber = subscriber
//        self.url = url
//        loadImage()
//    }
//    
//    func request(_ demand: Subscribers.Demand) {
//        // Not needed in this case, as image loading is handled in loadImage()
//    }
//    
//    func cancel() {
//        subscriber = nil
//    }
//    
//    private func loadImage() {
//        // Simulate an async image fetch
//        DispatchQueue.global().async {
//            do {
//                let data = try Data(contentsOf: self.url)
//                if let image = UIImage(data: data) {
//                    _ = self.subscriber?.receive(image)
//                    self.subscriber?.receive(completion: .finished)
//                } else {
//                    self.subscriber?.receive(completion: .failure(NSError(domain: "ImageLoaderError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to create image"])))
//                }
//            } catch {
//                self.subscriber?.receive(completion: .failure(error))
//            }
//        }
//    }
//}
