import UIKit
import AVFoundation

class GamesViewController: UIViewController {
    
    private let gameImageView = UIImageView()
    private let titleLabel = UILabel()
    private let yearLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let pageControl = UIPageControl()
    private var audioPlayer: AVAudioPlayer?
    
    private var currentIndex = 0
    
    private let games: [(title: String, year: String, description: String, image: String, sound: String)] = [
        (NSLocalizedString("game.title.1", comment: ""), NSLocalizedString("game.year.1", comment: ""), NSLocalizedString("game.description.1", comment: ""), "0", "select.wav"),
        (NSLocalizedString("game.title.2", comment: ""), NSLocalizedString("game.year.2", comment: ""), NSLocalizedString("game.description.2", comment: ""), "1", "select.wav"),
        (NSLocalizedString("game.title.3", comment: ""), NSLocalizedString("game.year.3", comment: ""), NSLocalizedString("game.description.3", comment: ""), "2", "select.wav"),
        (NSLocalizedString("game.title.4", comment: ""), NSLocalizedString("game.year.4", comment: ""), NSLocalizedString("game.description.4", comment: ""), "3", "select.wav"),
        (NSLocalizedString("game.title.5", comment: ""), NSLocalizedString("game.year.5", comment: ""), NSLocalizedString("game.description.5", comment: ""), "4", "select.wav"),
        (NSLocalizedString("game.title.6", comment: ""), NSLocalizedString("game.year.6", comment: ""), NSLocalizedString("game.description.6", comment: ""), "5", "select.wav"),
        (NSLocalizedString("game.title.7", comment: ""), NSLocalizedString("game.year.7", comment: ""), NSLocalizedString("game.description.7", comment: ""), "6", "select.wav"),
        (NSLocalizedString("game.title.8", comment: ""), NSLocalizedString("game.year.8", comment: ""), NSLocalizedString("game.description.8", comment: ""), "7", "select.wav")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupGestures()
        updateUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        
        // Configuración del ImageView
        gameImageView.contentMode = .scaleAspectFit
        gameImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gameImageView)
        
        // Configuración del título
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        // Configuración del año
        yearLabel.font = UIFont.systemFont(ofSize: 18)
        yearLabel.textColor = .lightGray
        yearLabel.textAlignment = .center
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(yearLabel)
        
        // Configuración de la descripción
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textColor = .gray
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        
        // Configuración del PageControl
        pageControl.numberOfPages = games.count
        pageControl.currentPage = currentIndex
        pageControl.pageIndicatorTintColor = .gray
        pageControl.currentPageIndicatorTintColor = .red
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageControl)
        
        // Layout con Auto Layout
        NSLayoutConstraint.activate([
            gameImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            gameImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gameImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            gameImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            
            titleLabel.topAnchor.constraint(equalTo: gameImageView.bottomAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            yearLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            yearLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: yearLabel.bottomAnchor, constant: 5),
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            pageControl.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupGestures() {
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(nextGame))
        leftSwipe.direction = .left
        view.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(previousGame))
        rightSwipe.direction = .right
        view.addGestureRecognizer(rightSwipe)
    }
    
    private func updateUI() {
        let game = games[currentIndex]
        
        UIView.transition(with: gameImageView, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.gameImageView.image = UIImage(named: game.image)
        }, completion: nil)
        
        titleLabel.text = game.title
        yearLabel.text = "game.releaseYear".localized(with: game.year)
        descriptionLabel.text = game.description
        pageControl.currentPage = currentIndex
        
        playSound(named: game.sound)
    }
    
    @objc private func nextGame() {
        currentIndex = (currentIndex + 1) % games.count
        updateUI()
    }
    
    @objc private func previousGame() {
        currentIndex = (currentIndex - 1 + games.count) % games.count
        updateUI()
    }
    
    private func playSound(named soundName: String) {
        guard let soundURL = Bundle.main.url(forResource: soundName, withExtension: nil) else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.play()
        } catch {
            print("Error al reproducir sonido: \(error.localizedDescription)")
        }
    }
}
