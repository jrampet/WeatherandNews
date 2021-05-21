// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let countryCoordinates = try? newJSONDecoder().decode(CountryCoordinates.self, from: jsonData)

import Foundation

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let countryCoordinates = try? newJSONDecoder().decode(CountryCoordinates.self, from: jsonData)

import Foundation

// MARK: - CountryCoordinates
struct CityNames: Codable {
    let message, cod: String
    let count: Int
    let list: [List]
}

// MARK: - List
struct List: Codable {
    let id: Int
    let name: String
    let coord: Coord
    let main: MainClass
    let dt: Int
    let wind: Wind
    let sys: Sys
    let rain, snow: JSONNull?
    let clouds: Clouds
    let weather: [Weather]
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int
}

// MARK: - Coord
struct Coord: Codable {
    let lat, lon: Double
}

// MARK: - MainClass
struct MainClass: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity: Int
    let seaLevel, grndLevel: Int?

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}

// MARK: - Sys
struct Sys: Codable {
    let country: String
}



// MARK: - Weather
struct WeatherCity: Codable {
    let id: Int
    let main: String
    let weatherDescription: String
    let icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}





// MARK: - Wind
struct Wind: Codable {
    let speed: Double
    let deg: Int
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
    func hash(into hasher: inout Hasher) {
        
    }
}

