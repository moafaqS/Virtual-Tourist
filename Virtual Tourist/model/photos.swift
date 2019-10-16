//
//  photos.swift
//  Virtual Tourist
//
//  Created by moafaq waleed simbawa on 15/02/1441 AH.
//  Copyright © 1441 moafaq. All rights reserved.
//

import Foundation


struct ResposePhotosObject : Codable{
    let photos : Photos
    let stat : String
}

struct Photos : Codable{
    let page : Int
    let pages : Int
    let perpage : Int
    let total : String
    let photo: [photo]
    
    enum CodingKeys: String, CodingKey {
        case page
        case pages
        case perpage
        case total
        case photo
        
    }
}

struct photo : Codable{
    let id : String
    let owner : String
    let secret : String
    let server : String
    let farm : Int
    let title : String
    let ispublic : Int
    let isfriend : Int
    let isfamily : Int
    
 
}
