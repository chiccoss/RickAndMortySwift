//
//  PaginationInformation.swift
//  RickAndMortySwift
//
//  Created by Sohayb Bahi on 24/02/2021.
//

import Foundation

struct PaginationInformation {
    let count : Int
    let pages : Int
    let nextUrl : URL?
    let previousUrl : URL?
}

extension PaginationInformation : Decodable {
    enum CodingKeys: String,CodingKey {
        case count
        case pages
        case nextUrl = "next"
        case previousUrl = "prev"
    }
}
