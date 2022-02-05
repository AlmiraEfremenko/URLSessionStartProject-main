//
//  ViewController.swift
//  URLSessionStartProject
//
//  Created by Alexey Pavlov on 29.11.2021.
//

import UIKit
import CryptoKit

class ViewController: UIViewController {

    private let endpointClient = EndpointClient(applicationSettings: ApplicationSettingsService())

    override func viewDidLoad() {
        super.viewDidLoad()
        
        executeCall()
    }
    
    func executeCall() {
        let endpoint = GetNameEndpoint()
        let completion: EndpointClient.ObjectEndpointCompletion<String> = { result, response in
            guard let responseUnwrapped = response else { return }

            print("\n\n response = \(responseUnwrapped.allHeaderFields) ;\n \(responseUnwrapped.statusCode) \n")
            switch result {
            case .success(let team):
                print("team = \(team)")
                
            case .failure(let error):
                print(error)
            }
        }
        
        endpointClient.executeRequest(endpoint, completion: completion)
    }
}

final class GetNameEndpoint: ObjectResponseEndpoint<String> {
    
    override var method: RESTClient.RequestType { return .get }
    override var path: String { "/v1/public/characters" }

//    override var queryItems: [URLQueryItem(name: "id", value: "1")]?
    
    override init() {
        super.init()
        
        //два параметра в дополнение к параметру apikey: ts - метка времени (или другая длинная строка, которая может изменяться по запросу) и хэш - md5 дайджест параметра ts, вашего закрытого ключа и вашего открытого ключа (например, md5(ts+privateKey+publicKey)
           
        let ts = "\(NSDate.timeIntervalSinceReferenceDate)"
        let privateKey = "2f3d52d12632c67e4216515e55de3266b6deb788"
        let publicKey = "e69ccc99cbd4f72ea3f5f6daff29d4cf"
        let hash = MD5(string: ts + privateKey + publicKey)
        
        queryItems = [URLQueryItem(name: "name", value: "Groot"),
                      URLQueryItem(name: "ts", value: ts),
                      URLQueryItem(name: "apikey", value: publicKey),
                      URLQueryItem(name: "hash", value: hash)]
    }
    
    func MD5(string: String) -> String {
        let digest = Insecure.MD5.hash(data: string.data(using: .utf8) ?? Data())
        
        return digest.map {
            String(format: "%02hhx", $0)
        }.joined()
    }
}

func decodeJSONOld() {
    let str = """
        {\"team\": [\"ios\", \"android\", \"backend\"]}
    """
    
    let data = Data(str.utf8)

    do {
        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            if let names = json["team"] as? [String] {
                print(names)
            }
        }
    } catch let error as NSError {
        print("Failed to load: \(error.localizedDescription)")
    }
}
