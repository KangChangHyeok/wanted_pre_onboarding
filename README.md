# iOS 프리온보딩 코스 사전과제
## 프로젝트 소개
- 날씨 정보를 출력하는 프로젝트입니다.

## 기술 스택

### Swift
- Swift 5
- UIKit
### 뷰 드로잉
- Only Code
### 백엔드
- OpenweatherAPI
### 네트워킹
- URLSession
### 개발 아키텍처 및 디자인 패턴
- MVC
## 기능
첫 화면에서는 간단한 도시의 날씨 정보를 표시하고, 셀을 터치하여 전환된 화면에서는 좀더 자세한 날씨 정보를 표시합니다.

## 구현
![Simulator Screen Shot - iPhone 12 Pro Max - 2022-09-14 at 12 48 19](https://user-images.githubusercontent.com/89637673/190056359-656f9e54-92ff-4e94-93bb-0d3a11b1b833.png)
![Simulator Screen Shot - iPhone 12 Pro Max - 2022-09-14 at 12 48 24](https://user-images.githubusercontent.com/89637673/190056365-f778f5f7-3267-4ea8-95f6-36ff18aa6350.png)
### 네트워킹

- 각 도시의 이름을 담은 배열을 만들고, forEach함수를 이용해서 각 도시에 대한 데이터를 받아옵니다.
- 또한 날씨 이미지를 가져오기 위해 다시 한번 icon값을 바탕으로한 URL 객체를 만들어 UIImage로 변환한 각 도시의 날씨 이미지를 cityWeatherImages 배열에 저장합니다.
- 두 배열에 모든 도시의 정보가 담긴 경우 escaping closure가 실행됩니다.

<details>
<summary>코드 보기</summary>
<div markdown="1">

####  NetworkManager

```swift
struct NetworkManager {
    
    func getCityWeatherDatas(completion: @escaping ([CityWeatherData?],[UIImage]) -> Void) {
        let cityNames: [String] = ["Gongju","Gwangju","Gumi","Gunsan","Daegu","Daejeon","Mokpo","Busan","Seosan","Seoul","Suwon","Suncheon","Ulsan","Iksan","Jeonju","Jeju","Cheonan","Cheongju","Chuncheon"]
        var cityWeatherDatas = [CityWeatherData?]()
        var cityWeatherImages = [UIImage]()
        cityNames.forEach {
            let weatherURL = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\($0)&appid=8f6e8afd2e9509eb87d30e402e7d5cbb")!
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
```      
</div>
</details>

### 첫번째 화면

- setupData함수에서 받아온 데이터를 사용할 변수에 담아 활용합니다.
- 셀이 선택될 경우 사용할 데이터를 넘기고 화면을 이동합니다.

<details>
<summary>코드 보기</summary>
<div markdown="1">

####  FirstViewController

```swift
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
```      
</div>
</details>

### 두번째 화면

- 받아온 데이터를 바탕으로 화면에 상세 날씨 정보를 표시합니다.

<details>
<summary>코드 보기</summary>
<div markdown="1">

####  SecondViewController

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

```      
</div>
</details>
