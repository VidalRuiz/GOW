import UIKit

class WeaponsCell: UITableViewCell {
    
    // Nombre del arma
    let wName: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Descripción del arma
    let wDescription: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Imagen del arma
    let wImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // Inicializador principal
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .black  // Fondo negro para la celda
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Configuración de la UI
    private func setupUI() {
        contentView.addSubview(wImage)
        contentView.addSubview(wName)
        contentView.addSubview(wDescription)

        // Asegurar que la descripción no se colapse
        wDescription.setContentHuggingPriority(.defaultLow, for: .vertical)
        wDescription.setContentCompressionResistancePriority(.required, for: .vertical)

        NSLayoutConstraint.activate([
            // Imagen del arma
            wImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            wImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            wImage.widthAnchor.constraint(equalToConstant: 80),
            wImage.heightAnchor.constraint(equalToConstant: 80),

            // Nombre del arma
            wName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            wName.leadingAnchor.constraint(equalTo: wImage.trailingAnchor, constant: 10),
            wName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

            // Descripción del arma
            wDescription.topAnchor.constraint(equalTo: wName.bottomAnchor, constant: 5),
            wDescription.leadingAnchor.constraint(equalTo: wImage.trailingAnchor, constant: 10),
            wDescription.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            wDescription.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
}
