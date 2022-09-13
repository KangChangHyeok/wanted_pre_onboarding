//
//  NetworkManager.swift
//  wanted_pre_onboarding
//
//  Created by 강창혁 on 2022/09/13.
//

import Foundation
import UIKit


struct NetworkManager {
    
    func getCityWeatherDatas(completion: @escaping ([CityWeatherData?],[UIImage]) -> Void) {
        let cityNames: [String] = ["Gongju","Gwangju","Gumi","Gunsan","Daegu","Daejeon","Mokpo","Busan","Seosan","Seoul","Suwon","Suncheon","Ulsan","Iksan","Jeonju","Jeju","Cheonan","Cheongju","Chuncheon"]
        var cityWeatherDatas = [CityWeatherData?]()
        var cityWeatherImages = [UIImage]()
        for cityName in cityNames {
            let weatherURL = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=8f6e8afd2e9509eb87d30e402e7d5cbb")!
            URLSession.shared.dataTask(with: weatherURL) { data, response, error in
                if error != nil {
                    print(error!)
                    return
                }
                guard let safeData = data else { return }
                let cityData = parseJSON(safeData)
                cityWeatherDatas.append(cityData)
                
                guard let icon = cityData?.weather?[0].icon else { return }
                guard let weatherImageURL = URL(string: "http://openweathermap.org/img/wn/\(icon)@2x.png") else { return }
                DispatchQueue.global().async {
                    if let imageData = try? Data(contentsOf: weatherImageURL) {
                        if let UIImageData = UIImage(data: imageData) {
                            cityWeatherImages.append(UIImageData)
                        }
                    }
                    if cityWeatherDatas.count == 19, cityWeatherImages.count == 19 {
                        completion(cityWeatherDatas, cityWeatherImages)
                    }
                }
            }.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> CityWeatherData? {
        do {
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(CityWeatherData.self, from: weatherData)
            return decodedData
        } catch {
            return nil
        }
    }
}
