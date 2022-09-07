import UIKit


struct WeatherColors { //strange! There is another way!

    static let shared = WeatherColors()
    
    let hot = UIColor.init(cgColor: CGColor(red: 226/255.0, green: 114/255.0, blue: 100/255.0, alpha: 1))
    let littleHot = UIColor.init(cgColor: CGColor(red: 231/255.0, green: 164/255.0, blue: 84/255.0, alpha: 1))
    //let littleHot = UIColor(red: 231, green: 164, blue: 84, alpha: 1)
    let normal = UIColor.init(cgColor: CGColor(red: 236/255.0, green: 198/255.0, blue: 73/255.0, alpha: 1))
    let littleCold = UIColor.init(cgColor: CGColor(red: 164/255.0, green: 215/255.0, blue: 176/255.0, alpha: 1))
    let cold = UIColor.init(cgColor: CGColor(red: 64/255.0, green: 105/255.0, blue: 137/255.0, alpha: 1))
    
    func color(temperature: Double) -> UIColor {
        switch(temperature) {
        case _ where temperature > 30:
            return hot
        case 20...30:
            return littleHot
        case 10..<20:
            return normal
        case 0..<10:
            return littleCold
        case _ where temperature < 0:
            return cold
        default:
            return UIColor.white
        }
    }
    
    private init() {}
}
