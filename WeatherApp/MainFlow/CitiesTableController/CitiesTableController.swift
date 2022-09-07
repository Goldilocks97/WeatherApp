import UIKit


final class CitiesTableController: UITableViewController {
    
    var data: [String] {
        didSet {
            if !forbiddenReloadData {
                tableView.reloadData()
            }
        }
    }
    var forbiddenReloadData = false
    
    private let cellID = "cellID"
    
    var onFinishing: (() -> Void)?
    var onConfigurationCell: ((String, @escaping ((_ forecast: WeatherForecast) -> Void)) -> Void)?
    var onSelectingCell: ((String) -> Void)?
    var onDeletingRow: ((String) -> Void)?

    init(data: [String]) {
        self.data = data
        super.init(style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewController Life Cycle Events
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        navigationItem.hidesBackButton = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Weather"
        navigationController?.navigationBar.barTintColor = .blue.withAlphaComponent(0.7)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    // MARK: - Supply TableView
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            onDeletingRow?(data[indexPath.section])
            print(data.count)
            tableView.performBatchUpdates {
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onSelectingCell?(data[indexPath.section])
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        if cell.contentView.viewWithTag(1) == nil {
            let cityLabel = UILabel()
            //cityLabel.sizeToFit()
            cityLabel.tag = 1
            cityLabel.text = "-"
            cityLabel.textColor = .white
            cityLabel.font = UIFont(name: "GillSans-BoldItalic", size: 30)
            cityLabel.adjustsFontSizeToFitWidth = true
            cityLabel.minimumScaleFactor = 0.2
            cityLabel.translatesAutoresizingMaskIntoConstraints = false
            
            let tempLabel = UILabel()
            //tempLabel.sizeToFit()
            tempLabel.tag = 2
            tempLabel.text = "-"
            tempLabel.textColor = .white
            tempLabel.font = UIFont(name: "GillSans-BoldItalic", size: 30)
            tempLabel.adjustsFontSizeToFitWidth = true
            tempLabel.minimumScaleFactor = 0.2
            tempLabel.translatesAutoresizingMaskIntoConstraints = false
            
            cell.contentView.addSubview(cityLabel)
            cell.contentView.addSubview(tempLabel)
            
            NSLayoutConstraint.activate([
                cityLabel.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -5),
                cityLabel.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -5),
                cityLabel.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 5),
                
                tempLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 5),
                tempLabel.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 5),
                tempLabel.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -5)
            ])
        }
        onConfigurationCell?(data[indexPath.section]) { [weak self] (forecast) in
            guard
                let cityLabel = cell.contentView.viewWithTag(1) as? UILabel,
                let tempLabel = cell.contentView.viewWithTag(2) as? UILabel
            else { return }
            cityLabel.text = self?.data[indexPath.section]
            tempLabel.text = String(Int(forecast.main.temp))
//            var config = cell.defaultContentConfiguration()
//            let addition = String(forecast.main.feelsLike)
            cell.backgroundColor = WeatherColors.shared.color(temperature: forecast.main.temp)
//            config.text = (self?.data[indexPath.section] ?? " ") + addition
//            cell.contentConfiguration = config
        }
        return cell
    }
}
