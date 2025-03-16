//
//  CharacterCell.swift
//  GOW
//
//  Created by ruizvi | VIDAL RUIZ VARGAS on 16/03/25.
//

import UIKit

/// Celda personalizada para mostrar personajes en la lista.
class CharacterCell: UITableViewCell {
    
    // MARK: - UI Elements
    
    /// Imagen del personaje.
    let cImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    /// Nombre del personaje.
    let cName: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Descripción del personaje.
    let cDescription: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Inicialización
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configurar UI
    
    /// Configura la interfaz de la celda.
    private func setupUI() {
        addSubview(cImage)
        addSubview(cName)
        addSubview(cDescription)
        
        NSLayoutConstraint.activate([
            // Imagen del personaje
            cImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            cImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            cImage.widthAnchor.constraint(equalToConstant: 80),
            cImage.heightAnchor.constraint(equalToConstant: 80),
            
            // Nombre del personaje
            cName.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            cName.leadingAnchor.constraint(equalTo: cImage.trailingAnchor, constant: 10),
            cName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            // Descripción del personaje
            cDescription.topAnchor.constraint(equalTo: cName.bottomAnchor, constant: 5),
            cDescription.leadingAnchor.constraint(equalTo: cImage.trailingAnchor, constant: 10),
            cDescription.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            cDescription.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
}
