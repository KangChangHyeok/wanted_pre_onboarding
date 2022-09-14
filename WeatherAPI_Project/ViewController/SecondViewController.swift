//
//  SecondViewController.swift
//  WeatherAPI_Project
//
//  Created by 강창혁 on 2022/09/13.
//

import UIKit

class SecondViewController: UIViewController {
    
    //MARK: - property
    private lazy var weatherImage: UIImageView = {
        let weatherImage = UIImageView(image: cityWeatherImage)
        weatherImage.translatesAutoresizingMaskIntoConstraints = false
        return weatherImage
    }()
    private lazy var cityName: UILabel = {
       let cityName = UILabel()
        cityName.text = cityWeatherData?.name
        cityName.font = UIFont.systemFont(ofSize: 40)
        cityName.minimumScaleFactor = 0.1
        cityName.adjustsFontSizeToFitWidth = true
        cityName.numberOfLines = 0
        return cityName
    }()
    private lazy var weatherDescription: UILabel = {
        let weatherDescription = UILabel()
        weatherDescription.text = cityWeatherData?.weather?[0].weatherDescription
        weatherDescription.font = UIFont.systemFont(ofSize: 30)
        weatherDescription.textColor = .lightGray
        weatherDescription.minimumScaleFactor = 0.1
        weatherDescription.adjustsFontSizeToFitWidth = true
        weatherDescription.numberOfLines = 0
        return weatherDescription
    }()
    private lazy var titleStackView: UIStackView = {
        let titleStackView = UIStackView(arrangedSubviews: [cityName, weatherDescription])
        titleStackView.translatesAutoresizingMaskIntoConstraints = false
        titleStackView.axis = .vertical
        titleStackView.alignment = .fill
        titleStackView.distribution = .fillEqually
        titleStackView.spacing = 0
        return titleStackView
    }()
    private lazy var temp: UILabel = {
        let temp = UILabel()
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.text = "온도"
        temp.font = UIFont.systemFont(ofSize: 30)
        temp.minimumScaleFactor = 0.1
        temp.adjustsFontSizeToFitWidth = true
        temp.numberOfLines = 0
        return temp
    }()
    private lazy var currentTemp: UILabel = {
        let currentTemp = UILabel()
        if let currentTempValue = cityWeatherData?.main?.temp {
            currentTemp.text = "현재기온: " + String(round((currentTempValue - 273.15) * 10) / 10) + "℃"
        }
        currentTemp.font = UIFont.systemFont(ofSize: 20)
        currentTemp.minimumScaleFactor = 0.1
        currentTemp.adjustsFontSizeToFitWidth = true
        currentTemp.numberOfLines = 0
        return currentTemp
    }()
    private lazy var sensibleTemp: UILabel = {
        let sensibleTemp = UILabel()
        if let sensibleTempValue = cityWeatherData?.main?.feelsLike {
            sensibleTemp.text = "체감기온: " + String(round((sensibleTempValue - 273.15) * 10) / 10) + "℃"
        }
        sensibleTemp.font = UIFont.systemFont(ofSize: 20)
        sensibleTemp.minimumScaleFactor = 0.1
        sensibleTemp.adjustsFontSizeToFitWidth = true
        sensibleTemp.numberOfLines = 0
        return sensibleTemp
    }()
    private lazy var highestTemp: UILabel = {
        let highestTemp = UILabel()
        if let highestTempValue = cityWeatherData?.main?.tempMax {
            highestTemp.text = "최고기온: " + String(round((highestTempValue - 273.15) * 10) / 10) + "℃"
        }
        highestTemp.font = UIFont.systemFont(ofSize: 20)
        highestTemp.minimumScaleFactor = 0.1
        highestTemp.adjustsFontSizeToFitWidth = true
        highestTemp.numberOfLines = 0
        return highestTemp
    }()
    private lazy var minimumTemp: UILabel = {
        let minimumTemp = UILabel()
        if let minimumTempValue = cityWeatherData?.main?.tempMin {
            minimumTemp.text = "최저기온: " + String(round((minimumTempValue - 273.15) * 10) / 10) + "℃"
        }
        minimumTemp.font = UIFont.systemFont(ofSize: 20)
        minimumTemp.minimumScaleFactor = 0.1
        minimumTemp.adjustsFontSizeToFitWidth = true
        minimumTemp.numberOfLines = 0
        return minimumTemp
    }()
    private lazy var tempStackView: UIStackView = {
        let tempStackView = UIStackView(arrangedSubviews: [currentTemp, sensibleTemp, highestTemp, minimumTemp])
        tempStackView.translatesAutoresizingMaskIntoConstraints = false
        tempStackView.axis = .vertical
        tempStackView.alignment = .fill
        tempStackView.distribution = .equalSpacing
        tempStackView.spacing = 10
        return tempStackView
    }()
    private lazy var currentHumidity: UILabel = {
        let currentHumidity = UILabel()
        currentHumidity.translatesAutoresizingMaskIntoConstraints = false
        currentHumidity.text = "현재습도"
        currentHumidity.font = UIFont.systemFont(ofSize: 30)
        currentHumidity.minimumScaleFactor = 0.1
        currentHumidity.adjustsFontSizeToFitWidth = true
        currentHumidity.numberOfLines = 0
        return currentHumidity
    }()
    private lazy var currentHumidityValue: UILabel = {
        let currentHumidityLabel = UILabel()
        if let currentHumidityValue = cityWeatherData?.main?.humidity {
            currentHumidityLabel.text = String(currentHumidityValue) + "%"
        }
        currentHumidityLabel.translatesAutoresizingMaskIntoConstraints = false
        currentHumidityLabel.font = UIFont.systemFont(ofSize: 20)
        currentHumidityLabel.minimumScaleFactor = 0.1
        currentHumidityLabel.adjustsFontSizeToFitWidth = true
        currentHumidityLabel.numberOfLines = 0
        return currentHumidityLabel
    }()
    private lazy var pressure: UILabel = {
        let pressure = UILabel()
        pressure.translatesAutoresizingMaskIntoConstraints = false
        pressure.text = "기압"
        pressure.font = UIFont.systemFont(ofSize: 30)
        pressure.minimumScaleFactor = 0.1
        pressure.adjustsFontSizeToFitWidth = true
        pressure.numberOfLines = 0
        return pressure
    }()
    private lazy var pressureValue: UILabel = {
        let pressureLabel = UILabel()
        if let pressureValue = cityWeatherData?.main?.pressure {
            pressureLabel.text = String(pressureValue) + " hPa"
        }
        pressureLabel.translatesAutoresizingMaskIntoConstraints = false
        pressureLabel.font = UIFont.systemFont(ofSize: 20)
        pressureLabel.minimumScaleFactor = 0.1
        pressureLabel.adjustsFontSizeToFitWidth = true
        pressureLabel.numberOfLines = 0
        return pressureLabel
    }()
    private lazy var windSpeed: UILabel = {
        let windSpeed = UILabel()
        windSpeed.translatesAutoresizingMaskIntoConstraints = false
        windSpeed.text = "풍속"
        windSpeed.font = UIFont.systemFont(ofSize: 30)
        windSpeed.minimumScaleFactor = 0.1
        windSpeed.adjustsFontSizeToFitWidth = true
        windSpeed.numberOfLines = 0
        return windSpeed
    }()
    private lazy var windSpeedValue: UILabel = {
        let windSpeedLabel = UILabel()
        if let windSpeedValue = cityWeatherData?.main?.pressure {
            windSpeedLabel.text = String(windSpeedValue) + " Meter/second"
        }
        windSpeedLabel.translatesAutoresizingMaskIntoConstraints = false
        windSpeedLabel.font = UIFont.systemFont(ofSize: 20)
        windSpeedLabel.minimumScaleFactor = 0.1
        windSpeedLabel.adjustsFontSizeToFitWidth = true
        windSpeedLabel.numberOfLines = 0
        return windSpeedLabel
    }()
    var cityWeatherData: CityWeatherData?
    var cityWeatherImage: UIImage?
    
    //MARK: - override Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayout()
    }
    
    //MARK: - setup
    
    func setupView() {
        view.backgroundColor = .systemBackground
        [weatherImage, titleStackView, temp, tempStackView, currentHumidity, currentHumidityValue, pressure, pressureValue, windSpeed, windSpeedValue].forEach {
            view.addSubview($0)
        }
    }
    func setupLayout() {
        NSLayoutConstraint.activate([
            weatherImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            weatherImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            weatherImage.widthAnchor.constraint(equalToConstant: 150),
            weatherImage.heightAnchor.constraint(equalToConstant: 150)])
        NSLayoutConstraint.activate([
            titleStackView.topAnchor.constraint(equalTo: weatherImage.topAnchor),
            titleStackView.leadingAnchor.constraint(equalTo: weatherImage.trailingAnchor),
            titleStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleStackView.bottomAnchor.constraint(equalTo: weatherImage.bottomAnchor)])
        NSLayoutConstraint.activate([
            temp.topAnchor.constraint(equalTo: weatherImage.bottomAnchor, constant: 30),
            temp.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)])
        NSLayoutConstraint.activate([
            tempStackView.topAnchor.constraint(equalTo: temp.bottomAnchor, constant: 10),
            tempStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30)])
        NSLayoutConstraint.activate([
            currentHumidity.topAnchor.constraint(equalTo: tempStackView.bottomAnchor, constant: 30),
            currentHumidity.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)])
        NSLayoutConstraint.activate([
            currentHumidityValue.topAnchor.constraint(equalTo: currentHumidity.bottomAnchor, constant: 10),
            currentHumidityValue.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30)])
        NSLayoutConstraint.activate([
            pressure.topAnchor.constraint(equalTo: currentHumidityValue.bottomAnchor, constant: 30),
            pressure.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)])
        NSLayoutConstraint.activate([
            pressureValue.topAnchor.constraint(equalTo: pressure.bottomAnchor, constant: 10),
            pressureValue.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30)])
        NSLayoutConstraint.activate([
            windSpeed.topAnchor.constraint(equalTo: pressureValue.bottomAnchor, constant: 30),
            windSpeed.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)])
        NSLayoutConstraint.activate([
            windSpeedValue.topAnchor.constraint(equalTo: windSpeed.bottomAnchor, constant: 10),
            windSpeedValue.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30)])
    }
}
