import UIKit


protocol CitiesTableModuleFactoriable {

    func makeCitiesTableModule(cities: [String]) -> CitiesTableController
    
}
