protocol Routerable: Presentable {

  func present(_ module: Presentable?)
  func present(_ module: Presentable?, animated: Bool)

  func dismissModule()
  func dismissModule(animated: Bool, completion: (() -> Void)?)

}
