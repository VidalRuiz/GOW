import UIKit

class WeaponsViewController: UIViewController, UITabBarDelegate {
    
    // UI Elements
    private let factionImageView = UIImageView()
    private let factionLabel = UILabel()
    private let weaponTableView = UITableView()
    private let tabBar = UITabBar()
    
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
        configureTabBar()
        
        // Cargar armas según la selección inicial
        updateWeapons(isCGO: isCGOActive)
    }
    
    // MARK: - Configuración UI
    private func setupUI() {
        
        view.backgroundColor = UIColor(named: "GOWBlack1")
        
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
        
        // Tab Bar
        tabBar.delegate = self
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        tabBar.backgroundColor = UIColor(named: "GOWBlack1")
        view.addSubview(tabBar)
        
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
            weaponTableView.bottomAnchor.constraint(equalTo: tabBar.topAnchor, constant: -10),

            tabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: - Configurar Tabla
    private func configureTableView() {
        weaponTableView.dataSource = self
        weaponTableView.delegate = self
        weaponTableView.register(WeaponsCell.self, forCellReuseIdentifier: "weaponCell")
    }
    
    // MARK: - Configurar TabBar
    private func configureTabBar() {
        let cogTab = UITabBarItem(title: "COG", image: UIImage(systemName: "shield"), tag: 0)
        let locustTab = UITabBarItem(title: "Locust", image: UIImage(systemName: "flame"), tag: 1)
        tabBar.items = [cogTab, locustTab]
        tabBar.selectedItem = isCGOActive ? cogTab : locustTab

        // Configurar apariencia en iOS 15+
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.black  // Color negro de fondo

            // Estilos para ítems no seleccionados
            appearance.stackedLayoutAppearance.normal.iconColor = .gray
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.gray]

            // Estilos para ítems seleccionados
            appearance.stackedLayoutAppearance.selected.iconColor = .white
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.white]

            // Aplicar a la TabBar
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        } else {
            // Para versiones menores a iOS 15
            tabBar.barTintColor = .black
            tabBar.tintColor = .white
            tabBar.unselectedItemTintColor = .gray
        }
    }
    
    // MARK: - Manejo de TabBar
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let showingCGO = item.tag == 0
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
