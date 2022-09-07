import UIKit


protocol CoordinatorFactoriable {
    
    func makeMainCoordinator(router: Router) -> MainCoordinator

}
