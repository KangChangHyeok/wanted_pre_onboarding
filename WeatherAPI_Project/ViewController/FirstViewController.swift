//
//  ViewController.swift
//  wanted_pre_onboarding
//
//  Created by 강창혁 on 2022/09/13.
//

import UIKit

class FirstViewController: UIViewController {
    
    //MARK: - property
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.rowHeight = 100
        return tableView
    }()
    
    private let networkManager = NetworkManager()
    private var cityWeatherDatas = [CityWeatherData?]()
    private var cityWeatherImages = [UIImage]()
    
    //MARK: - override Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayout()
        setupData()
    }
    
    //MARK: - setup
    
    func setupView() {
        self.view.addSubview(tableView)
    }
    func setupLayout() {
        NSLayoutConstraint.activate([tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                                     tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                                     tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                                     tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)])
        
    }
    func setupData() {
        networkManager.getCityWeatherDatas { cityWeatherDatas, images  in
            self.cityWeatherDatas = cityWeatherDatas
            self.cityWeatherImages = images
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

//MARK: - extension

extension FirstViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityWeatherDatas.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        cell.cityName.text = cityWeatherDatas[indexPath.row]?.name
        cell.weatherImage.image = cityWeatherImages[indexPath.row]
        if let temp = cityWeatherDatas[indexPath.row]?.main?.temp {
            cell.cityTemp.text = "온도: " + String(round((temp - 273.15) * 10) / 10) + "℃"
        }
        if let humidity = cityWeatherDatas[indexPath.row]?.main?.humidity {
            cell.cityHumidity.text = "습도: " + String(humidity) + "%"
        }
        return cell
    }
}

extension FirstViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let secondVC = SecondViewController()
        secondVC.cityWeatherData = cityWeatherDatas[indexPath.row]
        secondVC.cityWeatherImage = cityWeatherImages[indexPath.row]
        self.present(secondVC, animated: true)
    }
}
