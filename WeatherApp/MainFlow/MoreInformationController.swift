import UIKit


final class MoreInformationController: UIViewController {
    
    var data: [MoreInformationDataNames: Double]? {
        didSet {
            collectionView.reloadData()
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    var gestureHandler: (() -> Void)?
    
    private let cellID = "cellID"
    private let firstViewInCollectionTag = 1
    
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: prepareCompositionalLayout())
        collection.dataSource = self
        return collection
    }()
    
    private lazy var swipeGesture: UISwipeGestureRecognizer = {
        let rec = UISwipeGestureRecognizer(target: self, action: #selector(onGesture))
        rec.direction = .down
        return rec
    }()
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        let rec = UITapGestureRecognizer(target: self, action: #selector(onGesture))
        return rec
    }()
    
    private lazy var contentView: UIView  = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.backgroundColor = .white
        return view
    }()
    
    private var grabber: UIView = {
        let grabber = UIView()
        grabber.backgroundColor = .gray
        grabber.layer.cornerRadius = 2
        return grabber
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellID)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.addGestureRecognizer(swipeGesture)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addGestureRecognizer(tapGesture)
        view.addSubview(contentView)
        
        grabber.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(grabber)
        
        NSLayoutConstraint.activate([
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 3/5),
        
            grabber.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1/100),
            grabber.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1/9),
            grabber.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            grabber.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5)])

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: grabber.bottomAnchor, constant: 5)
        ])
    }
    
    @objc private func onGesture() {
        gestureHandler?()
    }
    
    private func prepareCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(4/9), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(2/7))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .flexible(5)
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
        section.interGroupSpacing = 10
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func retrieveCellData(for name: MoreInformationDataNames) -> String {
        if let v = data?[name] {
            if name == .sunSet || name == .sunRise {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm"
                return dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(Int(v))))
            }
            return String(Int(v))
        }
        return  ""
    }
    
    private func cellData(indexPath: IndexPath) -> (UIImage?, String, String) {
        switch(indexPath.item) {
        case 0:
            let image = UIImage(systemName: "wind")
            let value = retrieveCellData(for: .wind)
            return (image, "Wind speed", value)
        case 1:
            let image = UIImage(systemName: "figure.walk")
            let value = retrieveCellData(for: .feelsLike)
            return (image, "Feels Like", value)
        case 2:
            let image = UIImage(systemName: "minus.circle")
            let value = retrieveCellData(for: .minTemp)
            return (image, "Min Temperature", value)
        case 3:
            let image = UIImage(systemName: "plus.circle")
            let value = retrieveCellData(for: .maxTemp)
            return (image, "Max Temperature", value)
        case 4:
            let image = UIImage(systemName: "sunrise")
            let value = retrieveCellData(for: .sunRise)
            return (image, "Sun Rise", value)
        case 5:
            let image = UIImage(systemName: "sunset")
            let value = retrieveCellData(for: .sunSet)
            return (image, "Sun Set", value)
        default:
            let image = UIImage(systemName: "exclamationmark.triangle")
            let value = retrieveCellData(for: .wind)
            return (image, "No data...", value)
        }
    }

    private func configureCell(_ cell: UICollectionViewCell, indexPath: IndexPath) {
        if let curTemp = data?[.curTemp] {
            cell.contentView.backgroundColor = WeatherColors.shared.color(temperature: curTemp)
        } else {
            cell.contentView.backgroundColor = .gray
        }
        let dataView = UIView()
        // add a tag to dataView and configure data of its subviews later after dequeue
        dataView.backgroundColor = .white
        dataView.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(dataView)
        
        
        let (image, name, value) = cellData(indexPath: indexPath)
        
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let nameLabel = UILabel()
        
        nameLabel.text = name
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.2
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let headerStack = UIStackView(arrangedSubviews: [imageView, nameLabel])
        headerStack.translatesAutoresizingMaskIntoConstraints = false
        headerStack.axis = .horizontal
        cell.contentView.addSubview(headerStack)
        headerStack.distribution = .equalSpacing
        
        let valueLabel = UILabel()
        valueLabel.textAlignment = .center
        valueLabel.text = value
        valueLabel.adjustsFontSizeToFitWidth = true
        valueLabel.minimumScaleFactor = 0.2
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        dataView.addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            dataView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -10),
            dataView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 10),
            dataView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -10),
            dataView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 35),
        
            valueLabel.bottomAnchor.constraint(equalTo: dataView.bottomAnchor),
            valueLabel.topAnchor.constraint(equalTo: dataView.topAnchor),
            valueLabel.leadingAnchor.constraint(equalTo: dataView.leadingAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: dataView.trailingAnchor),
            
            headerStack.leadingAnchor.constraint(equalTo: dataView.leadingAnchor),
            headerStack.trailingAnchor.constraint(equalTo: dataView.trailingAnchor),
            headerStack.bottomAnchor.constraint(equalTo: dataView.topAnchor, constant: -3),
            headerStack.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 3)
        ])
    }
    
}


extension MoreInformationController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = data?.count {
            return count-1
        }
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        if cell.contentView.viewWithTag(firstViewInCollectionTag) == nil {
            configureCell(cell, indexPath: indexPath)
        }
        return cell
    }
    
    
}

enum MoreInformationData {
    case wind(Double)
    case feelsLike(Double)
    case minTemp(Double), maxTemp(Double)
    case sunRise(Int), sunSet(Int)
    case curTemp(Double)
}

enum MoreInformationDataNames {
    case wind, feelsLike, minTemp, maxTemp, sunRise, sunSet, curTemp
}
