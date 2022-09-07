import UIKit


final class WeatherPageController:
    UIPageViewController,
    UIPageViewControllerDelegate
{
    
    private lazy var addCityButton: CircleButton = {
        let image = UIImage(systemName: "globe.europe.africa.fill")
        let button = CircleButton(image: image)//, frame: CGRect(x: 90, y: 750, width: 90, height: 90))
        button.addTarget(self, action: #selector(doPlusButton), for: .touchUpInside)
        return button
    }()

    private lazy var moreInformationButton: CircleButton = {
        let button = CircleButton(image: childWeatherIcon)//, frame: CGRect(x: 290, y: 750, width: 90, height: 90))
        button.addTarget(self, action: #selector(doMoreInformation), for: .touchUpInside)
        return button
    }()
    
    private var childWeatherIcon: UIImage? {
        if let child = self.viewControllers?.first as? WeatherIcon {
            return child.preferredWeatherIcon
        }
        return nil
    }

    var onPlusCity: (() -> Void)?
    var onMoreInformation: ((String) -> Void)?

    func updateView() {
        if view.backgroundColor == viewControllers?.first?.preferedParentBackgroundColor &&
            moreInformationButton.myImageView.image == childWeatherIcon
        {
            return
        }
            
        moreInformationButton.myImageView.setImage(childWeatherIcon, animated: true)
        UIView.animate(withDuration: 0.25, delay: 0.0, options: [.allowUserInteraction]) {
            self.view.backgroundColor = self.viewControllers?.first?.preferedParentBackgroundColor ?? .clear
        }
    }

    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addCityButton.translatesAutoresizingMaskIntoConstraints = false
        moreInformationButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addCityButton)
        view.addSubview(moreInformationButton)
        NSLayoutConstraint.activate([
            addCityButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            addCityButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            addCityButton.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
            addCityButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
            
            moreInformationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            moreInformationButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            moreInformationButton.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
            moreInformationButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
        ])
    }

    @objc private func doPlusButton(_ sender: Any) {
        onPlusCity?()
    }
    
    @objc private func doMoreInformation(_ sender: Any) {
        guard let city = (viewControllers?.first as?  WeatherController)?.city else { return }
        onMoreInformation?(city)
    }

    // MARK: - PageViewControllerDelegate
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool)
    {
        guard completed == true else { return }
        updateView()
    }

}


final class CircleButton: UIButton {

    var myImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.borderWidth = 2
        iv.layer.borderColor = UIColor.black.cgColor
        return iv
    }()

    init(image: UIImage?) {
        super.init(frame: .zero)
        myImageView.image = image
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
        setupShadow()
    }

    private func setupShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.18
        layer.shadowOffset = .zero
        layer.shadowPath = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: .allCorners,
            cornerRadii: CGSize(width: bounds.width/2, height: bounds.width/2)).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }

    private func setup() {

        myImageView.backgroundColor = .systemGray5
        addSubview(myImageView)
        myImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            myImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2),
            myImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2),
            myImageView.topAnchor.constraint(equalTo: topAnchor, constant: 2),
            myImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2)])
        myImageView.layer.cornerRadius = myImageView.layer.bounds.width / 2
        myImageView.clipsToBounds = true

    }
    
}

extension UIImageView{
    func setImage(_ image: UIImage?, animated: Bool = true) {
        let duration = animated ? 0.3 : 0.0
        UIView.transition(
            with: self,
            duration: duration,
            options: [.allowUserInteraction, .showHideTransitionViews])
        {
            self.image = image
        }
    }
}
