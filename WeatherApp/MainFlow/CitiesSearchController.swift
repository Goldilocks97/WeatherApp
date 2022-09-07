import UIKit


final class CititesSearchController: UITableViewController {
    
    let cellID = "cellID"
    var tableData = [String]() {
        didSet { tableView.reloadData() }
    }

    var onSelectingCell: ((_ city: String) -> Void)?
    
    init() {
        super.init(style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        view.backgroundColor = .blue
    }

    // MARK: - TableView Supply
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.backgroundColor = .blue
        var config = cell.defaultContentConfiguration()
        config.text = tableData[indexPath.row]
        config.textProperties.color = .black
        cell.contentConfiguration = config
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onSelectingCell?(tableData[indexPath.row])
    }
    
}
