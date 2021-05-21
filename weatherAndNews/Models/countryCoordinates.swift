//
//  countryCoordinates.swift
//  weatherAndNews
//
//  Created by jeyaram-pt4154 on 20/05/21.
//

import Foundation


struct CountryCoordinate: Codable {
    let country: String
    let latitude, longitude: Itude
    let name: String
}

enum Itude: Codable {
    case double(Double)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Double.self) {
            self = .double(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(Itude.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Itude"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .double(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

typealias CountryCoordinates = [CountryCoordinate]


//struct CountryCoordinate: Codable{
//    let country : String
//    let latitude : Double
//    let longitude : Double
//    let name : String
//    enum CodingKeys: String, CodingKey {
//        case country,latitude,longitude,name
//
//    }
//}
//
//struct CoordinatesOfCountries: Codable{
//    let countries : [CountryCoordinates]
//}
//typealias CountryCoordinates = [CountryCoordinate]
