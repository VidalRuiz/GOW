import UIKit

class WeaponsViewController: UIViewController {
    
    @IBOutlet weak var wPoster: UIImageView!
    @IBOutlet weak var wTable: UITableView!
    
    // Data Source for weapons
    var arrayWeapons: [Weapon] = []
    
    // CGO Weapons
    let cgoWeapons: [Weapon] = [
        Weapon(id: 1, name: "weapon.name.lancer", description: "weapon.description.lancer", poster: "Mark1LancerAssaultRifle"),
        Weapon(id: 2, name: "weapon.name.lancer2", description: "weapon.description.lancer2", poster: "LancerMk2"),
        Weapon(id: 3, name: "weapon.name.sniper", description: "weapon.description.sniper", poster: "LongshotSniperRifle"),
        Weapon(id: 4, name: "weapon.name.hammer_of_dawn", description: "weapon.description.hammer_of_dawn", poster: "HammerOfDawn"),
        Weapon(id: 5, name: "weapon.name.mx8", description: "weapon.description.mx8", poster: "SnubPistol")
    ]
    
    // Locust Weapons
    let locusWeapons: [Weapon] = [
        Weapon(id: 1, name: "weapon.name.boomshot", description: "weapon.description.boomshot", poster: "Boomshot"),
        Weapon(id: 2, name: "weapon.name.hammerburstii", description: "weapon.description.hammerburstii", poster: "HammerburstII"),
        Weapon(id: 3, name: "weapon.name.mulcher", description: "weapon.description.mulcher", poster: "Mulcher"),
        Weapon(id: 4, name: "weapon.name.bolo_grenade", description: "weapon.description.bolo_grenade", poster: "BoloGrenade"),
        Weapon(id: 5, name: "weapon.name.boltok", description: "weapon.description.boltok", poster: "BoltokPistol")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up table view delegates
        wTable.dataSource = self
        wTable.delegate = self
        
        // Load the correct weapons set based on tab selection
        let tabItemTag = self.tabBarItem.tag
        arrayWeapons = (tabItemTag == Constants.tagCGO) ? cgoWeapons : locusWeapons
        
        // Add swipe gestures to switch between CGO and Locust weapons
        configureSwipeGestures()
    }
    
    /// Configures left and right swipe gestures to switch weapon categories
    private func configureSwipeGestures() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
    }
    
    /// Handles swipe gestures to switch between CGO and Locust weapons
    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .right {
            arrayWeapons = cgoWeapons
        } else if gesture.direction == .left {
            arrayWeapons = locusWeapons
        }
        wTable.reloadData()
    }
}

extension WeaponsViewController: UITableViewDataSource, UITableViewDelegate {
    
    /// Returns the number of weapons in the selected category
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayWeapons.count
    }
    
    /// Configures each weapon cell with localized names and descriptions
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WeaponsCell
        let weapon = arrayWeapons[indexPath.row]
        
        // Apply localized text for name and description
        cell.wName.text = weapon.name.localized
        cell.wDescription.text = weapon.description.localized
        
        // Set weapon image
        cell.wImage.image = UIImage(named: weapon.poster)
        
        return cell
    }
}
