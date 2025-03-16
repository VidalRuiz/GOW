import UIKit

class CharacterViewController: UIViewController, UITabBarDelegate {
    
    // UI Elements
    private let factionImageView = UIImageView()
    private let factionLabel = UILabel()
    private let characterTableView = UITableView()
    private let tabBar = UITabBar()
    
    // Data Source
    private var arrayCharacters: [Character] = []
    
    // COG Characters
    private let cogCharacters: [Character] = [
        Character(name: "Marcus Fenix", description: "character.description.marcus", image: "marcus_fenix"),
        Character(name: "Dom Santiago", description: "character.description.dom", image: "dom_santiago"),
        Character(name: "Baird", description: "character.description.baird", image: "damon_baird"),
        Character(name: "Cole Train", description: "character.description.cole", image: "augustus_cole"),
        Character(name: "Anya Stroud", description: "character.description.anya", image: "anya_stroud")
    ]
    
    // Locust Characters
    private let locustCharacters: [Character] = [
        Character(name: "General RAAM", description: "character.description.raam", image: "general_raam"),
        Character(name: "Skorge", description: "character.description.skorge", image: "skorge"),
        Character(name: "Karn", description: "character.description.karn", image: "karn"),
        Character(name: "Myrrah", description: "character.description.myrrah", image: "queen_myrrah"),
        Character(name: "Theron Guard", description: "character.description.theron", image: "theron_guard")
    ]
    
    // Track Current Selection
    private var isCGOActive = true

    override func viewDidLoad() {
        super.viewDidLoad()
        // Configurar el color de la Tab Bar
        setupUI()
        configureTableView()
        configureTabBar()
        
        // Cargar personajes según la selección inicial
        updateCharacters(isCGO: isCGOActive)
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
        
        // Tabla de personajes
        characterTableView.translatesAutoresizingMaskIntoConstraints = false
        characterTableView.backgroundColor = .clear
        view.addSubview(characterTableView)
        
        // Tab Bar
        tabBar.delegate = self
        tabBar.translatesAutoresizingMaskIntoConstraints = false

        
        view.addSubview(tabBar)
        
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
            characterTableView.bottomAnchor.constraint(equalTo: tabBar.topAnchor, constant: -10),

            tabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: - Configurar Tabla
    private func configureTableView() {
        characterTableView.dataSource = self
        characterTableView.delegate = self
        characterTableView.register(CharacterCell.self, forCellReuseIdentifier: "characterCell")
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
            updateCharacters(isCGO: showingCGO)
        }
    }
    
    private func updateCharacters(isCGO: Bool) {
        
        isCGOActive = isCGO
        arrayCharacters = isCGO ? cogCharacters : locustCharacters
        factionLabel.text = isCGO ? "Coalition of Ordered Governments" : "Locust Horde"
        
        // Asigna la imagen de la facción
        factionImageView.image = UIImage(named: isCGO ? "headerGOW" : "headerLocus")
        
        UIView.transition(with: characterTableView, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.characterTableView.reloadData()
        }, completion: nil)
    }
}

// MARK: - UITableViewDataSource y UITableViewDelegate
extension CharacterViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayCharacters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "characterCell", for: indexPath) as? CharacterCell else {
            return UITableViewCell()
        }
        
        let character = arrayCharacters[indexPath.row]
        cell.cName.text = character.name.localized
        cell.cDescription.text = character.description.localized
        cell.cImage.image = UIImage(named: character.image)

        return cell
    }
}
