import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

class NetworkManager {
    
    static let shared = NetworkManager()
        
        private init() {} // Private initializer to prevent external instantiation
    
    func requestData<T: Codable>(url: URL, method: HTTPMethod, parameters: [String: Any]?, completion: @escaping (Result<T, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        print(parameters?.description ?? "no params")
        
        if let parameters = parameters {
            if method == .post {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: parameters)
                    request.httpBody = jsonData
                } catch {
                    completion(.failure(error))
                    return
                }
            }
            else if method == .get {
                let queryItems = parameters.map { URLQueryItem(name: $0.key, value: String(describing: $0.value)) }
                var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
                urlComponents?.queryItems = queryItems
                request.url = urlComponents?.url
            }
        }
        // cache control directives to prevent caching
        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // ..add header fields here
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(.failure(error!))
                return
            }
            print("res is: \(String(data: data, encoding: .utf8) ?? "problem")")
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(T.self, from: data)
                completion(.success(decodedData))
            } catch let error {
                completion(.failure(error))
            }
        }.resume()
    }
}
