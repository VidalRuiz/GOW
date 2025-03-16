import UIKit

/// Controlador para la vista de armas en Gears of War.
/// Permite visualizar armas de la facción COG o Locust y cambiar entre ellas con gestos de deslizamiento.
class WeaponsViewController: UIViewController {
    
    // MARK: - UI Elements
    
    /// Imagen representativa de la facción seleccionada (COG o Locust).
    private let factionImageView = UIImageView()
    
    /// Etiqueta con el nombre de la facción seleccionada.
    private let factionLabel = UILabel()
    
    /// Tabla para mostrar la lista de armas de la facción seleccionada.
    private let weaponTableView = UITableView()
    
    /// Overlay para mostrar transiciones entre facciones.
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
    
    /// Indicador visual para señalar la posibilidad de cambiar de facción con un swipe.
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
    
    /// Arreglo que almacena las armas de la facción actualmente seleccionada.
    private var arrayWeapons: [Weapon] = []
    
    /// Arreglo de armas pertenecientes a la Coalición de Gobiernos Ordenados (COG).
    private let cgoWeapons: [Weapon] = [
        Weapon(id: 1, name: "weapon.name.lancer", description: "weapon.description.lancer", poster: "Mark1LancerAssaultRifle"),
        Weapon(id: 2, name: "weapon.name.lancer2", description: "weapon.description.lancer2", poster: "LancerMk2"),
        Weapon(id: 3, name: "weapon.name.sniper", description: "weapon.description.sniper", poster: "LongshotSniperRifle"),
        Weapon(id: 4, name: "weapon.name.hammer_of_dawn", description: "weapon.description.hammer_of_dawn", poster: "HammerOfDawn"),
        Weapon(id: 5, name: "weapon.name.mx8", description: "weapon.description.mx8", poster: "SnubPistol")
    ]
    
    /// Arreglo de armas pertenecientes a la Horda Locust.
    private let locustWeapons: [Weapon] = [
        Weapon(id: 1, name: "weapon.name.boomshot", description: "weapon.description.boomshot", poster: "Boomshot"),
        Weapon(id: 2, name: "weapon.name.hammerburstii", description: "weapon.description.hammerburstii", poster: "HammerburstII"),
        Weapon(id: 3, name: "weapon.name.mulcher", description: "weapon.description.mulcher", poster: "Mulcher"),
        Weapon(id: 4, name: "weapon.name.bolo_grenade", description: "weapon.description.bolo_grenade", poster: "BoloGrenade"),
        Weapon(id: 5, name: "weapon.name.boltok", description: "weapon.description.boltok", poster: "BoltokPistol")
    ]
    
    /// Estado actual de la facción activa (true = COG, false = Locust).
    private var isCGOActive = true

    // MARK: - Ciclo de Vida

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        configureTableView()
        configureGestures()
        
        // Cargar armas de la facción inicial
        updateWeapons(isCGO: isCGOActive)
    }
    
    // MARK: - Configuración UI
    
    /// Configura la interfaz de usuario, añadiendo elementos y restricciones de AutoLayout.
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
        
        // Tabla de armas
        weaponTableView.translatesAutoresizingMaskIntoConstraints = false
        weaponTableView.backgroundColor = .clear
        view.addSubview(weaponTableView)
        
        // Configuración de constraints
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
            weaponTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
        ])
    }
    
    // MARK: - Configurar Tabla
    
    /// Configura la tabla para mostrar las armas.
    private func configureTableView() {
        weaponTableView.dataSource = self
        weaponTableView.delegate = self
        weaponTableView.register(WeaponsCell.self, forCellReuseIdentifier: "weaponCell")
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
        let showingCGO = gesture.direction == .right
        if isCGOActive != showingCGO {
            updateWeapons(isCGO: showingCGO)
        }
    }
    
    /// Actualiza la interfaz de usuario con la facción seleccionada.
    private func updateWeapons(isCGO: Bool) {
        isCGOActive = isCGO
        arrayWeapons = isCGO ? cgoWeapons : locustWeapons
        factionLabel.text = isCGO ? "Coalition of Ordered Governments" : "Locust Horde"
        factionImageView.image = UIImage(named: isCGO ? "headerGOW" : "headerLocus")
        
        factionOverlay.text = isCGO ? "💙 Coalition of Ordered Governments" : "🔥 Locust Horde"
        factionOverlay.alpha = 1
        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseOut, animations: {
            self.factionOverlay.alpha = 0
        })
        
        UIView.transition(with: weaponTableView, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.weaponTableView.reloadData()
        })
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
