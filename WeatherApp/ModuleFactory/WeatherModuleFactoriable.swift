protocol WeatherModuleFactoriable {
    
    func makeWeatherForecastModule(forecast: WeatherForecast?, city: String) -> WeatherController

}
