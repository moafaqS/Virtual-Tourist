//
//  API.swift
//  Virtual Tourist
//
//  Created by moafaq waleed simbawa on 15/02/1441 AH.
//  Copyright © 1441 moafaq. All rights reserved.
//

import Foundation


class API {
    struct constants {
        static let apiKey = "455331b8a53a6e4b6f35b61bee2bc94a"
        static let apiSecret = "dfdf613c8c7e27bf"
        static let base = "www.flickr.com/services/rest"
        static let method = "flickr.photos.search"
        static let perpage = 10
        
    }
    
    
    static func constructUrl(latitude : Double , longitude : Double , page : Int  ) -> URLComponents{
        
        var requestUrl = URLComponents()
        requestUrl.scheme = "https"
        requestUrl.path = constants.base
        let method = URLQueryItem(name: "method", value: constants.method)
        let apikey = URLQueryItem(name: "api_key", value: constants.apiKey)
        let format = URLQueryItem(name: "format", value: "json")
        let format2 = URLQueryItem(name: "nojsoncallback", value: "1")
        let lat = URLQueryItem(name: "lat", value: String(latitude))
        let lon = URLQueryItem(name: "lon", value: String(longitude))
        let perPage = URLQueryItem(name: "per_page", value: String(constants.perpage))
        let page = URLQueryItem(name: "per_page", value: String(page))
        
        
        
        requestUrl.queryItems = [method , apikey , format,format2 , lat , lon, perPage , page]
                  
        return requestUrl

    }

   
    
   
    
    static func getPhotoes(latitude : Double , longitude : Double , page : Int , completionHandler : @escaping (Photos?,Error?) -> Void){
        
        let url = constructUrl(latitude: latitude, longitude: longitude, page: page)
        let request = URLRequest(url: url.url!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if error != nil { // Handle error…
                completionHandler(nil,error)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResposePhotosObject.self, from: data!)
                completionHandler(responseObject.photos,nil)
            }catch{
                completionHandler(nil,error)
            }

           
        }
        
        task.resume()
    
    }
    
    
    static func getImage(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
