import UIKit


final class ModuleFactory:
    WeatherModuleFactoriable,
    WeatherPageModuleFactoriable,
    CitiesTableModuleFactoriable,
    CitiesSearchModuleFactoriable,
    MoreInformationFactoriable
{
    
    func makeMoreInformationController() -> MoreInformationController {
        return MoreInformationController()
    }
    
    func makeWeatherPageModule() -> WeatherPageController {
        return WeatherPageController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }

    func makeCititesSearchModule() -> CititesSearchController {
        return CititesSearchController()
    }
        
    func makeWeatherForecastModule(forecast: WeatherForecast?, city: String) -> WeatherController {
        return WeatherController(forecast: forecast, city: city)
    }

    func makeCitiesTableModule(cities: [String]) -> CitiesTableController {
        return CitiesTableController(data: cities)
    }
    
}
