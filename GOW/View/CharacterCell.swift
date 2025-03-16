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
    let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    /// Nombre del personaje.
    let characterNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Descripción del personaje.
    let characterDescriptionLabel: UILabel = {
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
        addSubview(characterImageView)
        addSubview(characterNameLabel)
        addSubview(characterDescriptionLabel)
        
        NSLayoutConstraint.activate([
            // Imagen del personaje
            characterImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            characterImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            characterImageView.widthAnchor.constraint(equalToConstant: 80),
            characterImageView.heightAnchor.constraint(equalToConstant: 80),
            
            // Nombre del personaje
            characterNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            characterNameLabel.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 10),
            characterNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            // Descripción del personaje
            characterDescriptionLabel.topAnchor.constraint(equalTo: characterNameLabel.bottomAnchor, constant: 5),
            characterDescriptionLabel.leadingAnchor.constraint(equalTo: characterImageView.trailingAnchor, constant: 10),
            characterDescriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            characterDescriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
}
