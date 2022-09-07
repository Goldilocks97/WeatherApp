import UIKit


class CitiesCell: UITableViewCell {
    
    private let cellID = "cellID"
    private var city = ""
    private var temp = 0.0
    
    init() {
        super.init(style: .default, reuseIdentifier: cellID)
        
        let cityLabel = UILabel()
        cityLabel.tag = 1
        cityLabel.text = city
        cityLabel.textColor = .white
        cityLabel.font = UIFont(name: "GillSans-BoldItalic", size: 30)
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let tempLabel = UILabel()
        tempLabel.tag = 2
        tempLabel.text = city
        tempLabel.textColor = .white
        tempLabel.font = UIFont(name: "GillSans-BoldItalic", size: 30)
        tempLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cityLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 15),
            cityLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 15),
            
            tempLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            tempLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
