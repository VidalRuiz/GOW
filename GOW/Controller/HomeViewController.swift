import UIKit

class HomeViewController: UITableViewController {
    
    @IBOutlet var menuTableView: UITableView!
    
    let menuOptions: [MenuOption] = [
        MenuOption(title: "menu.option.videogames", image: "gamecontroller.fill", segue: "gamesSegue"),
        MenuOption(title: "menu.option.weapons", image: "shield.fill", segue: "weaponsSegue"),
        MenuOption(title: "menu.option.characters", image: "person.crop.rectangle.stack.fill", segue: "charactersSegue"),
        MenuOption(title: "menu.option.merchandise", image: "shippingbox.fill", segue: "merchandiseSegue")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configurar el color de fondo desde Assets.xcassets
        view.backgroundColor = UIColor(named: "GOWBlack1")
        menuTableView.backgroundColor = UIColor(named: "GOWBlack1")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuOptions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuOptionCell

        let menuOption = menuOptions[indexPath.row]

        // Texto localizado
        cell.menuLabel.text = NSLocalizedString(menuOption.title, comment: "")

        // Colores
        cell.backgroundColor = UIColor(named: "GOWBlack1") // Fondo negro
        cell.menuLabel.textColor = UIColor(named: "GOWText") // Texto blanco o gris claro

        // Configurar íconos en color blanco
        if let icon = UIImage(systemName: menuOption.image) {
            cell.menuImage.image = icon.withTintColor(UIColor(named: "GOWRed") ?? .white, renderingMode: .alwaysOriginal)
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: menuOptions[indexPath.row].segue, sender: self)
    }
}
