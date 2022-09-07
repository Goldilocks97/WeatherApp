import Foundation
import UIKit


final class MainCoordinator: BaseCoordinator {

    private let router: Router
    private let moduleFactory: ModuleFactory
    private let modelWeather: WeatherModel
    private var modelCitiesSearch: CitiesSearchModel
    
    private var pageController: WeatherPageController?
    private var citiesSearchController: CititesSearchController?

    // MARK: - Coordinator interface
    override func start() {
        showWeatherForecasts()
    }
    
    override func didEnterBackGround() {
        modelWeather.saveCities()
    }

    init(router: Router) {
        self.router = router
        self.moduleFactory = ModuleFactory()
        self.modelWeather = WeatherModel()
        self.modelCitiesSearch = CitiesSearchModel()
        super.init()
    }

    //MARK: - Private methods
    private func showWeatherForecasts() {
        if pageController == nil {
            pageController = moduleFactory.makeWeatherPageModule()
        }
        pageController!.dataSource = self
        pageController!.delegate = pageController
        router.push(pageController, animated: true)
        let controller = makeWeatherForecastModule(option: .first)
        router.setPage(pageController: pageController!, module: controller, animated: true) // force unwrapping
        pageController?.onPlusCity = { [weak self] in
            self?.showCitiesTable()
        }
        pageController?.onMoreInformation = { [weak self] (city) in
            self?.showMoreInformation(city: city)
        }
    }
    
    private func showMoreInformation(city: String) {
        let moreInformationController = moduleFactory.makeMoreInformationController()
        moreInformationData(for: city) { moreInformationController.data = $0 }
        moreInformationController.modalPresentationStyle = .overCurrentContext
        moreInformationController.gestureHandler = { [weak self] in
            self?.router.dismissModule()
        }
        router.present(moreInformationController)
    }

    private func showCitiesTable() {
        let tableController = moduleFactory.makeCitiesTableModule(cities: modelWeather.cities)
        configurateCitiesTable(tableController)
        router.push(tableController, animated: true)
    }

    private func makeWeatherForecastModule(
        option: WeatherForecastOption
    ) -> WeatherController?
    {
        var name: String
        switch(option) {
        case .first:
            guard let cityName = modelWeather.cities.first else { return nil }
            name = cityName
        case .city(let cityName):
            name = cityName
        default:
            return nil
        }
        let controller = moduleFactory.makeWeatherForecastModule(
            forecast: nil, city: name)
        modelWeather.forecast(for: name) { [weak self] forecast in
            controller.forecast = forecast
            self?.pageController?.updateView()
        }
        return controller
    }

    private enum WeatherForecastOption {
        case first, current
        case city(_ name:String)
    }
    
    private func goToWeatherPage(of city: String) {
        guard let pc = pageController else { return }
        let controller = makeWeatherForecastModule(option: .city(city)) // forcw unwrapping
        router.setPage(pageController: pc, module: controller, animated: false)
        router.popModule(animated: true)
        
        // Work around a bug with using cached neibour controllers
        // Rather than asks data source
        pc.dataSource = nil
        pc.dataSource = self
        pc.updateView()
    }
    
    private func moreInformationData(
        for city: String,
        handler: @escaping ([MoreInformationDataNames: Double]) -> Void) {
        modelWeather.forecast(for: city) { forecast in
            var data = [MoreInformationDataNames: Double]()
            data[.wind] = forecast.wind.speed
            data[.feelsLike] = forecast.main.feelsLike
            data[.minTemp] = forecast.main.tempMin
            data[.maxTemp] = forecast.main.tempMax
            data[.sunRise] = Double(forecast.sys.sunrise)
            data[.sunSet] = Double(forecast.sys.sunset)
            data[.curTemp] = forecast.main.temp
            handler(data)
        }
    }

    private func configurateCitiesTable(_ tableController: CitiesTableController) {
        let searcherController = moduleFactory.makeCititesSearchModule()
        searcherController.onSelectingCell = { [weak self] city in
            self?.modelWeather.cities.append(city)
            tableController.data = (self?.modelWeather.cities)! //force unwrapping
            tableController.navigationItem.searchController?.isActive = false
            self?.citiesSearchController?.tableData = []
        }
        citiesSearchController = searcherController
        
        tableController.navigationItem.searchController = UISearchController(
            searchResultsController: searcherController)
        tableController.navigationItem.searchController?.searchResultsUpdater = self
        
        tableController.onSelectingCell = { [weak self] (city) in
            self?.goToWeatherPage(of: city)
        }

        tableController.onConfigurationCell = { [weak self] (city, handler) in
            self?.modelWeather.forecast(for: city) { handler($0) }
        }
        
        tableController.onDeletingRow = { [weak self] (city) in
            self?.modelWeather.removeCity(city)
            tableController.forbiddenReloadData = true
            tableController.data.removeFirst { $0 == city }
            tableController.forbiddenReloadData = false
        }
    }

}


extension MainCoordinator: UIPageViewControllerDataSource {
    
    // MARK: - Supply of PageViewController
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore
        viewController: UIViewController
    ) -> UIViewController? {
        return self.pageViewController(viewController, nextPossition: .before)
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        return self.pageViewController(viewController, nextPossition: .after)
    }

    private func pageViewController(
        _ viewController: UIViewController,
        nextPossition possition: PossitionInPageController) -> UIViewController?
    {
        guard
            let controller = (viewController as? WeatherController),
            let city = controller.city,
            let index = modelWeather.cities.firstIndex(where: { $0 == city })
        else { return nil }
        var nextIndex: Int
        switch(possition) {
        case .before:
            nextIndex = index - 1
        case .after:
            nextIndex = index + 1
        }
        guard nextIndex >= 0,
              nextIndex < modelWeather.cities.count
        else { return nil }
        return makeWeatherForecastModule(option: .city(modelWeather.cities[nextIndex]))
    }

    private enum PossitionInPageController {
        case before
        case after
    }

}


extension MainCoordinator: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        //suspend pendingOperation if empty JUST PRINT IN isCancel CONDITION?
        //restrict speed of internet to test
        guard
            let input = searchController.searchBar.text,
            !input.isEmpty
        else { return }
        modelCitiesSearch.findCities(input: input) { [weak self] (data) in
            if let controller = self?.citiesSearchController {
                controller.tableData = data
            }
            //self?.citiesSearchController?.tableData = data
        }
    }

}
