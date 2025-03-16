//
//  CharacterViewController.swift
//  GOW
//
//  Created by ruizvi | VIDAL RUIZ VARGAS on 16/03/25.
//

import UIKit

/// Controlador de vista para mostrar los personajes de Gears of War.
class CharacterViewController: UIViewController {
    
    // MARK: - UI Elements
    
    /// Tabla para mostrar los personajes.
    private let characterTableView = UITableView()
    
    /// Imagen representativa de la facción (COG o Locust).
    private let factionImageView = UIImageView()
    
    /// Etiqueta para el nombre de la facción.
    private let factionLabel = UILabel()
    
    /// Overlay para indicar el cambio de facción con swipe.
    private let factionOverlay: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    /// Indicador visual para sugerir cambio de facción con swipe.
    private let swipeIndicator: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "⬅️ Swipe for Locust | Swipe for COG ➡️"
        label.alpha = 0.8
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Data Source
    

    
    /// Lista de personajes de la Coalición de Gobiernos Ordenados (COG).
    private let cogCharacters: [Character] = [
        Character(name: "character.name.marcus", description: "character.description.marcus", image: "marcus_fenix"),
        Character(name: "character.name.dom", description: "character.description.dom", image: "dom_santiago"),
        Character(name: "character.name.baird", description: "character.description.baird", image: "damon_baird"),
        Character(name: "character.name.cole", description: "character.description.cole", image: "augustus_cole"),
        Character(name: "character.name.anya", description: "character.description.anya", image: "anya_stroud")
    ]

    private let locustCharacters: [Character] = [
        Character(name: "character.name.raam", description: "character.description.raam", image: "general_raam"),
        Character(name: "character.name.skorge", description: "character.description.skorge", image: "skorge"),
        Character(name: "character.name.karn", description: "character.description.karn", image: "karn"),
        Character(name: "character.name.myrrah", description: "character.description.myrrah", image: "queen_myrrah"),
        Character(name: "character.name.theron", description: "character.description.theron", image: "theron_guard")
    ]
    
    /// Estado actual de la facción activa (true = COG, false = Locust).
    private var isCOGActive = true
    
    /// Lista de personajes actualmente mostrados.
    private var currentCharacters: [Character] = []
    
    // MARK: - Ciclo de Vida
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        configureTableView()
        configureGestures()
        
        // Cargar personajes iniciales
        updateCharacters(isCOG: isCOGActive)
    }
    
    // MARK: - Configuración UI
    
    /// Configura la interfaz de usuario, incluyendo la tabla y las etiquetas.
    private func setupUI() {
        view.backgroundColor = UIColor(named: "GOWBlack1")
        
        // Overlay de facción
        view.addSubview(factionOverlay)
        NSLayoutConstraint.activate([
            factionOverlay.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            factionOverlay.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            factionOverlay.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            factionOverlay.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Indicador de swipe
        view.addSubview(swipeIndicator)
        NSLayoutConstraint.activate([
            swipeIndicator.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            swipeIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // Imagen de la facción
        factionImageView.contentMode = .scaleAspectFit
        factionImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(factionImageView)
        
        // Nombre de la facción
        factionLabel.font = UIFont.boldSystemFont(ofSize: 22)
        factionLabel.textColor = .white
        factionLabel.textAlignment = .center
        factionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(factionLabel)
        
        // Tabla de personajes
        characterTableView.translatesAutoresizingMaskIntoConstraints = false
        characterTableView.backgroundColor = .clear
        view.addSubview(characterTableView)
        
        // Constraints
        NSLayoutConstraint.activate([
            factionImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            factionImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            factionImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            factionImageView.heightAnchor.constraint(equalToConstant: 100),
            
            factionLabel.topAnchor.constraint(equalTo: factionImageView.bottomAnchor, constant: 10),
            factionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            characterTableView.topAnchor.constraint(equalTo: factionLabel.bottomAnchor, constant: 10),
            characterTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            characterTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            characterTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
        ])
    }
    
    // MARK: - Configurar Tabla
    
    /// Configura la tabla para mostrar los personajes.
    private func configureTableView() {
        characterTableView.dataSource = self
        characterTableView.delegate = self
        characterTableView.register(CharacterCell.self, forCellReuseIdentifier: "characterCell")
    }
    
    // MARK: - Configurar Gestos
    
    /// Configura los gestos de swipe para cambiar entre facciones.
    private func configureGestures() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
    }
    
    // MARK: - Manejo de Swipes
    
    /// Maneja el cambio de facción cuando el usuario hace swipe.
    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        let showingCOG = gesture.direction == .right
        if isCOGActive != showingCOG {
            updateCharacters(isCOG: showingCOG)
        }
    }
    
    /// Actualiza la interfaz de usuario con la facción seleccionada.
    private func updateCharacters(isCOG: Bool) {
        isCOGActive = isCOG
        currentCharacters = isCOG ? cogCharacters : locustCharacters
        factionLabel.text = isCOG ? "Coalition of Ordered Governments" : "Locust Horde"
        factionImageView.image = UIImage(named: isCOG ? "headerGOW" : "headerLocus")
        
        UIView.transition(with: characterTableView, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.characterTableView.reloadData()
        })
    }
}
// MARK: - UITableViewDataSource y UITableViewDelegate
extension CharacterViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentCharacters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "characterCell", for: indexPath) as? CharacterCell else {
            return UITableViewCell()
        }
        
        let character = currentCharacters[indexPath.row]
        cell.characterNameLabel.text = character.name.localized
        cell.characterDescriptionLabel.text = character.description.localized
        cell.characterImageView.image = UIImage(named: character.image)
        
        return cell
    }
}
