import UIKit


final class CoordinatorFactory: CoordinatorFactoriable {
    
    func makeMainCoordinator(router: Router) -> MainCoordinator {
        return MainCoordinator(router: router)
    }
}
