// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI
import Combine

enum NetworkError: Error {
    case decodableError
    case networkError
    case unkownError
    case unvalidUrl
    case notimplementedyet
    
}

protocol NetworkService {
    func request<T:Decodable>(endoint: String, authmethod: Authmethod, headers:[String:String]?) -> AnyPublisher<T, NetworkError>
}

struct NetworkManager: NetworkService {
    func request<T>(endoint: String, authmethod: Authmethod = .get, headers:[String:String]? = nil) -> AnyPublisher<T, NetworkError> where T : Decodable {
        
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
        
        let res = URLSession.shared.dataTaskPublisher(for: urlReq)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                return   error is DecodingError ? NetworkError.decodableError : NetworkError.unkownError
            }.eraseToAnyPublisher()
        
        return res
    }
}

struct UserInfo: Decodable {
    var username: String
    var email: String
    var password: String
}

struct CreateSessionForUser: Decodable{
    var success: Bool
    var expires_at: String
    var request_token: String
}

protocol AuthProtocol {
 
    // Step 1
    func createRequestToken() -> AnyPublisher<CreateSessionForUser, NetworkError>
    //  step 2
    
    //https://www.themoviedb.org/authenticate/a10d5f0b2ce15afefda0275dc6b4ad76f261c9c5
    //redirect the user to  https://www.themoviedb.org/authenticate/{REQUEST_TOKEN}
    //  step3
    func createUserSession()
    //https://api.themoviedb.org/3/authentication/session/new
    
}

struct AuthReqToken: AuthProtocol {
    let networkManager : NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func createUserSession() {
        
        //        curl --request POST \
        //             --url https://api.themoviedb.org/3/authentication/session/new \
        //             --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI4MjE1Nzc1ZTk4NzBmMDI2Mjc1YjI4ZDdjMjVhNjlhNyIsIm5iZiI6MTcyNjk0MDczMS4wNzQxNzIsInN1YiI6IjVlNTkxNDAyYTkzZDI1MDAxNzU1NjhkMSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.o7Q9TVJ_Q7M1mbIHociYKb7eVtf4Wxy6mCa3EmY8vCk' \
        //             --header 'accept: application/json' \
        //             --header 'content-type: application/json'
        

    }
    
    func createRequestToken() -> AnyPublisher<CreateSessionForUser, NetworkError> {
        let endoint = "https://api.themoviedb.org/3/authentication/token/new"
        var headers: [String:String] = [:]
        headers["Authorization"] = "Bearer \(AuthManager.shared.getAppOwnerToken())"
        headers["accept"] = "application/json"
        
        return networkManager.request(endoint: endoint, headers: headers)
    }
    
}
enum Authmethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}

struct Movie: Decodable{
    
}

protocol AppService {
    func fetchmovies () -> AnyPublisher<[Movie],NetworkError>
}

struct MovieNetworkManager: AppService {
    
    let networkManager: NetworkManager
    
    init(networkService: NetworkService) {
        self.networkManager = NetworkManager()
    }
   
    func fetchmovies() -> AnyPublisher<[Movie], NetworkError> {
        let endoint = ""
        return networkManager.request(endoint: endoint, headers: ["token" : AuthManager.shared.getAuthToken()])
    }
}

class AuthManager {
    
    static var shared = AuthManager()
    
    private var authToken: String?
    
    func getAuthToken() -> String  {
        return ""
    }
    
    func setAuthToken() {
        // set token in keychain
    }
    
    func getAppOwnerToken() -> String{
        // return qpp qdmiin user session to use in Creqte req token
        // tò save somewhere
        return "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI4MjE1Nzc1ZTk4NzBmMDI2Mjc1YjI4ZDdjMjVhNjlhNyIsIm5iZiI6MTcyNjk0MDczMS4wNzQxNzIsInN1YiI6IjVlNTkxNDAyYTkzZDI1MDAxNzU1NjhkMSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.o7Q9TVJ_Q7M1mbIHociYKb7eVtf4Wxy6mCa3EmY8vCk"
    }
}

