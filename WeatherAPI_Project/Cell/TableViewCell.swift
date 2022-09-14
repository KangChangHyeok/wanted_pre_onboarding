//
//  TableViewCell.swift
//  wanted_pre_onboarding
//
//  Created by 강창혁 on 2022/09/13.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    //MARK: - property
    
    let weatherImage: UIImageView = {
        let weatherImage = UIImageView()
        weatherImage.translatesAutoresizingMaskIntoConstraints = false
        return weatherImage
    }()
    let cityName: UILabel = {
        let cityName = UILabel()
        cityName.translatesAutoresizingMaskIntoConstraints = false
        return cityName
    }()
    let cityTemp: UILabel = {
        let cityTemp = UILabel()
        cityTemp.text = "cityTemp"
        cityTemp.translatesAutoresizingMaskIntoConstraints = false
        return cityTemp
    }()
    let cityHumidity: UILabel = {
       let cityHumidity = UILabel()
        cityHumidity.text = "cityHumidity"
        cityHumidity.translatesAutoresizingMaskIntoConstraints = false
        return cityHumidity
    }()
    
    //MARK: - override Method
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupView()
        setupLayout()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - setup
    
    func setupView() {
        [weatherImage, cityName, cityTemp, cityHumidity].forEach {
            self.contentView.addSubview($0)
        }
    }
    func setupLayout() {
        NSLayoutConstraint.activate([
            weatherImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            weatherImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            weatherImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            weatherImage.widthAnchor.constraint(equalToConstant: 100)])
        NSLayoutConstraint.activate([
            cityName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            cityName.leadingAnchor.constraint(equalTo: weatherImage.trailingAnchor, constant: 20)])
        NSLayoutConstraint.activate([
            cityTemp.topAnchor.constraint(equalTo: cityName.bottomAnchor, constant: 20),
            cityTemp.leadingAnchor.constraint(equalTo: weatherImage.trailingAnchor, constant: 20)])
        NSLayoutConstraint.activate([
            cityHumidity.topAnchor.constraint(equalTo: cityTemp.topAnchor),
            cityHumidity.leadingAnchor.constraint(equalTo: cityTemp.trailingAnchor, constant: 20)])
    }
}
