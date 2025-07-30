import UIKit

class CollectionCell: UICollectionViewCell {
    static let identifier = "cell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .imageBlue
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    func setupUI() {
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        contentView.clipsToBounds = true
        contentView.backgroundColor = .systemGray6
        contentView.layer.cornerRadius = 15
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 120),
            
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            priceLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
        
    }
    
    func configure(with data: CellModel) {
        nameLabel.text = data.name
        priceLabel.text = "€ \(data.price)"
    }
}
