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
        return weatherImage
    }()
    let cityName: UILabel = {
        let cityName = UILabel()
        return cityName
    }()
    
    let cityTemp: UILabel = {
        let cityTemp = UILabel()
        cityTemp.text = "cityTemp"
        return cityTemp
    }()
    
    let cityHumidity: UILabel = {
       let cityHumidity = UILabel()
        cityHumidity.text = "cityHumidity"
        return cityHumidity
    }()
    //MARK: - override Method
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setupView() {
        [weatherImage, cityName, cityTemp, cityHumidity].forEach {
            self.contentView.addSubview($0)
        }
    }
    func setupLayout() {
        weatherImage.translatesAutoresizingMaskIntoConstraints = false
        weatherImage.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        weatherImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        weatherImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        weatherImage.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        cityName.translatesAutoresizingMaskIntoConstraints = false
        cityName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        cityName.leadingAnchor.constraint(equalTo: weatherImage.trailingAnchor, constant: 20).isActive = true
        
        cityTemp.translatesAutoresizingMaskIntoConstraints = false
        cityTemp.topAnchor.constraint(equalTo: cityName.bottomAnchor, constant: 20).isActive = true
        cityTemp.leadingAnchor.constraint(equalTo: weatherImage.trailingAnchor, constant: 20).isActive = true
        
        cityHumidity.translatesAutoresizingMaskIntoConstraints = false
        cityHumidity.topAnchor.constraint(equalTo: cityTemp.topAnchor).isActive = true
        cityHumidity.leadingAnchor.constraint(equalTo: cityTemp.trailingAnchor, constant: 20).isActive = true
        
    }
}
