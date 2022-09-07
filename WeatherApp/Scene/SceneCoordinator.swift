import Foundation
import UIKit


final class SceneCoordinator: BaseCoordinator {
    
    private let coordinatorFactory: CoordinatorFactoriable
    private let router: Router

    private var scenario: Scenarios
    private var currentFlow: Coordinatorable?
    let rootController = UINavigationController()

    // MARK: - Coordinator protocol
    override func start() {
        runWeatherFlow()
    }
    
    override init() {
        self.coordinatorFactory = CoordinatorFactory()
        self.router = Router(rootController: rootController)
        self.scenario = .main
        super.init()
    }
    
    // MARK: - Recieve scene events
    override func didEnterBackGround() {
        currentFlow?.didEnterBackGround()
    }

    // MARK: - Launching flows merhods
    private func runWeatherFlow() {
        let coordinator = coordinatorFactory.makeMainCoordinator(router: router)
        addDependency(coordinator)
        currentFlow = coordinator
        coordinator.start()
    }

    private enum Scenarios {
        case main
        //case firstLaunch
    }
}
