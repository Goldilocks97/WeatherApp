import Foundation


class BaseCoordinator: NSObject, Coordinatorable {
    
    //MARK: - child flows
    private var childCoordinators: [Coordinatorable] = []

    //MARK: - Coordinator interface
    func start() {}
    func didEnterBackGround() {}

    //MARK: - Control child flows
    func addDependency(_ coordinator: Coordinatorable) {
        guard !childCoordinators.contains(where: { $0 === coordinator }) else { return }
        childCoordinators.append(coordinator)
    }
    
    func removeDependency(_ coordinator: Coordinatorable?) {
        guard !childCoordinators.isEmpty else { return }
        
        childCoordinators.removeAll(where: { $0 === coordinator })
    }

    // We don't actually need init because coordinator's children are removed by ARC.
    // But we still can implement some actions if need before a coordinator disappeares.
    deinit {}
}
