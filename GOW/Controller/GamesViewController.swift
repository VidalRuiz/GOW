import UIKit

/// Estructura que representa un juego de Gears of War
struct Game {
    let title: String
    let releaseYear: Int
    let imageName: String
}

class GamesViewController: UIViewController {
    
    /// Lista de juegos con sus datos
    let games: [Game] = [
        Game(title: "Gears of War", releaseYear: 2006, imageName: "0"),
        Game(title: "Gears of War 2", releaseYear: 2008, imageName: "1"),
        Game(title: "Gears of War 3", releaseYear: 2011, imageName: "2"),
        Game(title: "Gears of War 4", releaseYear: 2016, imageName: "3"),
        Game(title: "Gears 5", releaseYear: 2019, imageName: "4"),
        Game(title: "Gears of War Judgment", releaseYear: 2013, imageName: "5"),
        Game(title: "Gears Tactics", releaseYear: 2020, imageName: "6"),
        Game(title: "Gears of War Ultimate Edition", releaseYear: 2015, imageName: "7")
    ]
    
    // UI Elements
    private let gameImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let gameTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = UIColor(named: "GOWText") ?? .white
        return label
    }()
    
    private let gameYearLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor(named: "GOWText") ?? .lightGray
        return label
    }()
    
    private let imagePageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.pageIndicatorTintColor = .gray
        pageControl.currentPageIndicatorTintColor = .red
        return pageControl
    }()
    
    private var currentIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureGestures()
        updateUI(for: currentIndex)
    }
    
    /// Configura la UI
    private func setupUI() {
        view.backgroundColor = UIColor(named: "GOWBlack1") ?? .black
        
        // Agregar elementos a la vista
        view.addSubview(gameImage)
        view.addSubview(gameTitleLabel)
        view.addSubview(gameYearLabel)
        view.addSubview(imagePageControl)
        
        // Configurar constraints
        gameImage.translatesAutoresizingMaskIntoConstraints = false
        gameTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        gameYearLabel.translatesAutoresizingMaskIntoConstraints = false
        imagePageControl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            gameImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            gameImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gameImage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            gameImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            
            gameTitleLabel.topAnchor.constraint(equalTo: gameImage.bottomAnchor, constant: 20),
            gameTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            gameYearLabel.topAnchor.constraint(equalTo: gameTitleLabel.bottomAnchor, constant: 10),
            gameYearLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            imagePageControl.topAnchor.constraint(equalTo: gameYearLabel.bottomAnchor, constant: 20),
            imagePageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        imagePageControl.numberOfPages = games.count
    }
    
    /// Configura los gestos de Swipe
    private func configureGestures() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
    }
    
    /// Maneja el cambio de imagen con Swipe
    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .right {
            currentIndex = (currentIndex + 1) % games.count
        } else if gesture.direction == .left {
            currentIndex = (currentIndex - 1 + games.count) % games.count
        }
        updateUI(for: currentIndex)
    }
    
    /// Actualiza la UI con el juego actual
    private func updateUI(for index: Int) {
        let game = games[index]
        gameImage.image = UIImage(named: game.imageName)
        gameTitleLabel.text = game.title
        gameYearLabel.text = "Año de lanzamiento: \(game.releaseYear)"
        imagePageControl.currentPage = index
    }
}
