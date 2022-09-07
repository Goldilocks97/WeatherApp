protocol NavigationControllable {
    
    func push(_ module: Presentable?)
    func push(_ module: Presentable?, hideBottomBar: Bool)
    func push(_ module: Presentable?, animated: Bool)
    func push(_ module: Presentable?, animated: Bool, completion: (() -> Void)?)
    func push(
        _ module: Presentable?,
        animated: Bool,
        hideBottomBar: Bool,
        completion: (() -> Void)?)

    func popModule()
    func popModule(animated: Bool)
    
    func setRootModule(_ module: Presentable?)
    func setRootModule(_ module: Presentable?, hideBar: Bool)

    func popToRootModule(animated: Bool)
    
}
