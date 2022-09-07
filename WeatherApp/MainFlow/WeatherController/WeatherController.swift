import UIKit


final class WeatherController: UIViewController, WeatherIcon {
    
    var city: String? {
        didSet {
            cityLabel.text = city
        }
    }
    
    private let interfaceComponents = WeatherInterfaceComponents.shared
    
    override var preferedParentBackgroundColor: UIColor? {
        guard forecast != nil else { return nil }
        return WeatherColors.shared.color(temperature: forecast!.main.temp)
    }
    
    var preferredWeatherIcon: UIImage? {
        let config = UIImage.SymbolConfiguration.preferringMulticolor()
        guard let main = forecast?.weather.first?.main else { return nil }
        switch(main) {
        //should be static function
        case "Clear":
            if let image = UIImage(systemName: "sun.max.fill", withConfiguration: config) {//make it constant and not constant
                return image
            }
        case "Clouds":
            if let image = UIImage(systemName: "cloud.fill", withConfiguration: config) {//make it constant and not constant
                return image
            }
        default:
            if let image = UIImage(systemName: "cloud.drizzle.fill", withConfiguration: config) {//make it constant and not constant
                return image
            }
        }
        return nil
    }
    
    var forecast: WeatherForecast? {
        didSet {
            temperatureLabel.text = String(Int(forecast!.main.temp)) + interfaceComponents.degreeSign
//            view.backgroundColor = WeatherColors.shared.color(temperature: forecast!.main.temp)
        }
    }
    
    //DELETE: NIZHE VAR USELESS
//    var backgroundColor: UIColor? {
//        guard forecast != nil else { return nil}
//        return WeatherColors.shared.color(temperature: forecast!.main.temp)
//    }
    private var temperatureLabel = UILabel()
    private var cityLabel = UILabel()

    private let backgroundColors = WeatherColors.shared

    
    init(forecast: WeatherForecast?, city: String) {
        self.forecast = forecast
        self.city = city
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //view.layer.addSublayer(gradientLayer)
        //view.backgroundColor = WeatherBroadcastColors.shared.hot
        view.backgroundColor = .clear
        var text = String(Int((forecast != nil ? forecast!.main.temp : 0)))
        temperatureLabel.textColor = .white
        temperatureLabel.text = String(text) + interfaceComponents.degreeSign
        temperatureLabel.textAlignment = .center
        //temperatureLabel.frame = CGRect(x: 90, y: 90, width: 300, height: 300)
        var font = UIFont(name: "GillSans-BoldItalic", size: 150)!
        temperatureLabel.font = font
        temperatureLabel.adjustsFontSizeToFitWidth = true
        temperatureLabel.minimumScaleFactor = 0.2
        //temperatureLabel.sizeToFit()
        //temperatureLabel.backgroundColor = .red
        //view.addSubview(temperatureLabel)
        //temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        text = city ?? ""
        font = UIFont(name: "GillSans-BoldItalic", size: 50)!
        cityLabel.adjustsFontSizeToFitWidth = true
        cityLabel.minimumScaleFactor = 0.2
        cityLabel.text = text
        cityLabel.textColor = .white
        cityLabel.font = font
        //cityLabel.sizeToFit()
        cityLabel.textAlignment = .center
        //cityLabel.backgroundColor = .blue
        
        //view.addSubview(cityLabel)
        //cityLabel.translatesAutoresizingMaskIntoConstraints = false
        //NSLayoutConstraint.activate([
        //    cityLabel.bottomAnchor.constraint(equalTo: temperatureLabel.topAnchor, constant: -10),
         //   cityLabel.leadingAnchor.constraint(equalTo: temperatureLabel.leadingAnchor)
            //cityLabel.heightAnchor.constraint(equalTo: temperatureLabel.heightAnchor, multiplier: 1/4)
            
      //  ])
        let stack = UIStackView(arrangedSubviews: [cityLabel, temperatureLabel])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 2/5),
            stack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 4/5),
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

    }
    
    
    
}

extension UIViewController {
    @objc var preferedParentBackgroundColor: UIColor? {
        get { return nil }
    }
}
