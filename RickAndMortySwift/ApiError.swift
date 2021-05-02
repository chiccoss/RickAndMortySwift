//
//  AppError.swift
//  RickAndMortySwift
//
//  Created by Sohayb Bahi on 24/02/2021.
//

import Foundation


enum ApiError : Error {
    case statusCode(Int)
    case invalidResponse
    case emptyResponse
    case mimeTypeError
}

