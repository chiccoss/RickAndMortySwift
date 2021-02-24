//
//  Character.swift
//  RickAndMortySwift
//
//  Created by Sohayb Bahi on 24/02/2021.
//

import Foundation


struct Character : Hashable {
    let identifier : Int
    let name : String
    let imageUrl : URL
    let createdDate : Date
}

extension Character: Decodable {
    enum CodingKeys: String,CodingKey {
        case identifier = "id"
        case name = "name"
        case imageUrl = "image"
        case createdDate = "created"
    }
}
