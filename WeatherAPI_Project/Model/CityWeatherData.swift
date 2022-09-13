//
//  Response.swift
//  wanted_pre_onboarding
//
//  Created by 강창혁 on 2022/09/13.
//
import Foundation

// MARK: - Response
struct CityWeatherData: Codable {
    let weather: [Weather]?
    let main: Main?
    let wind: Wind?
    let dt: Int?
    let name: String?
}

// MARK: - Main

struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double?
    let pressure, humidity: Int?

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
    }
}

// MARK: - Weather

struct Weather: Codable {
    let id: Int?
    let main, weatherDescription, icon: String?

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double?
    let deg: Int?
}


