import UIKit

class FilterSortButton: UIButton {
    
    // MARK: - Case
    
    enum Style {
        case sort
        case filter(count: Int?)
    }
    
    // MARK: - Init
    
    init(title: String, iconName: String, style: Style) {
        super.init(frame: .zero)
        setupUI(title: title, iconName: iconName, style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    
    private func setupUI(title: String, iconName: String, style: Style) {
        setupButtonConfiguration(title: title, iconName: iconName)
        setupStyleSpecificElements(style: style)
        setupConstraints()
    }
    
    private func setupButtonConfiguration(title: String, iconName: String) {
        var config = UIButton.Configuration.plain()
        config.title = title
        config.image = UIImage(systemName: iconName)
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 11, weight: .regular)
        config.imagePadding = 6
        config.imagePlacement = .leading
        config.baseForegroundColor = .label
        config.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 1, bottom: 6, trailing: 27)
        
        var background = UIButton.Configuration.plain().background
        background.backgroundColor = .systemBackground
        background.cornerRadius = 12
        background.strokeWidth = 1
        background.strokeColor = UIColor.systemGray3
        config.background = background
        
        self.configuration = config
        self.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .regular)
    }
    
    private func setupStyleSpecificElements(style: Style) {
        switch style {
        case .sort:
            setupSortStyle()
        case .filter:
            setupFilterStyle()
        }
    }
    
    private func setupSortStyle() {
        let config = UIImage.SymbolConfiguration(pointSize: 13, weight: .medium)
        let image = UIImage(systemName: "chevron.down", withConfiguration: config)
        let chevron = UIImageView(image: image)
        chevron.tintColor = .black
        chevron.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(chevron)
        NSLayoutConstraint.activate([
            chevron.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            chevron.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -13)
        ])
    }
    
    private func setupFilterStyle() {
        let badge = UILabel()
        badge.text = "12"
        badge.textColor = .white
        badge.backgroundColor = .systemBlue
        badge.font = .systemFont(ofSize: 12, weight: .bold)
        badge.textAlignment = .center
        badge.clipsToBounds = true
        badge.translatesAutoresizingMaskIntoConstraints = false
        badge.layer.cornerRadius = 10
        
        self.addSubview(badge)
        NSLayoutConstraint.activate([
            badge.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            badge.leadingAnchor.constraint(equalTo: self.titleLabel!.trailingAnchor, constant: 5),
            badge.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            badge.widthAnchor.constraint(greaterThanOrEqualToConstant: 20),
            badge.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func setupConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

