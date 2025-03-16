import UIKit

class WeaponsViewController: UIViewController {
    
    // UI Elements
    private let factionImageView = UIImageView()
    private let factionLabel = UILabel()
    private let weaponTableView = UITableView()
    private let factionOverlay: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.alpha = 0 // Inicialmente oculto
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
    
    // Data Source
    private var arrayWeapons: [Weapon] = []
    
    // CGO Weapons
    private let cgoWeapons: [Weapon] = [
        Weapon(id: 1, name: "weapon.name.lancer", description: "weapon.description.lancer", poster: "Mark1LancerAssaultRifle"),
        Weapon(id: 2, name: "weapon.name.lancer2", description: "weapon.description.lancer2", poster: "LancerMk2"),
        Weapon(id: 3, name: "weapon.name.sniper", description: "weapon.description.sniper", poster: "LongshotSniperRifle"),
        Weapon(id: 4, name: "weapon.name.hammer_of_dawn", description: "weapon.description.hammer_of_dawn", poster: "HammerOfDawn"),
        Weapon(id: 5, name: "weapon.name.mx8", description: "weapon.description.mx8", poster: "SnubPistol")
    ]
    
    // Locust Weapons
    private let locustWeapons: [Weapon] = [
        Weapon(id: 1, name: "weapon.name.boomshot", description: "weapon.description.boomshot", poster: "Boomshot"),
        Weapon(id: 2, name: "weapon.name.hammerburstii", description: "weapon.description.hammerburstii", poster: "HammerburstII"),
        Weapon(id: 3, name: "weapon.name.mulcher", description: "weapon.description.mulcher", poster: "Mulcher"),
        Weapon(id: 4, name: "weapon.name.bolo_grenade", description: "weapon.description.bolo_grenade", poster: "BoloGrenade"),
        Weapon(id: 5, name: "weapon.name.boltok", description: "weapon.description.boltok", poster: "BoltokPistol")
    ]
    
    // Track Current Selection
    private var isCGOActive = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        configureTableView()
        configureGestures()
        
        // Cargar armas según la selección inicial
        updateWeapons(isCGO: isCGOActive)
    }
    
    // MARK: - Configuración UI
    private func setupUI() {
        view.backgroundColor = .black
        
        view.addSubview(factionOverlay)

        NSLayoutConstraint.activate([
            factionOverlay.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            factionOverlay.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            factionOverlay.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            factionOverlay.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        view.addSubview(swipeIndicator)

        NSLayoutConstraint.activate([
            swipeIndicator.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            swipeIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        // Imagen de la facción
        factionImageView.contentMode = .scaleAspectFit
        factionImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(factionImageView)
        
        // Label de la facción
        factionLabel.font = UIFont.boldSystemFont(ofSize: 22)
        factionLabel.textColor = .white
        factionLabel.textAlignment = .center
        factionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(factionLabel)
        
        // Tabla de armas
        weaponTableView.translatesAutoresizingMaskIntoConstraints = false
        weaponTableView.backgroundColor = .clear
        view.addSubview(weaponTableView)
        
        // Constraints
        NSLayoutConstraint.activate([
            factionImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            factionImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            factionImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            factionImageView.heightAnchor.constraint(equalToConstant: 100),
            
            factionLabel.topAnchor.constraint(equalTo: factionImageView.bottomAnchor, constant: 10),
            factionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            weaponTableView.topAnchor.constraint(equalTo: factionLabel.bottomAnchor, constant: 10),
            weaponTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weaponTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            weaponTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100)        ])
    }
    
    // MARK: - Configurar Tabla
    private func configureTableView() {
        weaponTableView.dataSource = self
        weaponTableView.delegate = self
        weaponTableView.register(WeaponsCell.self, forCellReuseIdentifier: "weaponCell")
    }
    
    // MARK: - Configurar Gestos
    private func configureGestures() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
    }
    
    // MARK: - Manejo de Swipes
    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        let showingCGO = gesture.direction == .right
        if isCGOActive != showingCGO {
            updateWeapons(isCGO: showingCGO)
        }
    }
    
    private func updateWeapons(isCGO: Bool) {
        isCGOActive = isCGO
        arrayWeapons = isCGO ? cgoWeapons : locustWeapons
        factionLabel.text = isCGO ? "Coalition of Ordered Governments" : "Locust Horde"
        
        // Asigna la imagen de la facción
        factionImageView.image = UIImage(named: isCGO ? "headerGOW" : "headerLocus")
        factionOverlay.text = isCGO ? "💙 Coalition of Ordered Governments" : "🔥 Locust Horde"
        factionOverlay.alpha = 1

        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseOut, animations: {
            self.factionOverlay.alpha = 0
        })
        
        UIView.transition(with: weaponTableView, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.weaponTableView.reloadData()
        }, completion: nil)
    }
}

// MARK: - UITableViewDataSource y UITableViewDelegate
extension WeaponsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayWeapons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "weaponCell", for: indexPath) as? WeaponsCell else {
            return UITableViewCell()
        }
        
        let weapon = arrayWeapons[indexPath.row]
        cell.wName.text = weapon.name.localized
        cell.wDescription.text = weapon.description.localized
        cell.wImage.image = UIImage(named: weapon.poster)

        return cell
    }
}
