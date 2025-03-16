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
        ("game.title.1".localized, "game.year.1".localized, "game.description.1".localized, "0", "select.wav"),
        ("game.title.2".localized, "game.year.2".localized, "game.description.2".localized, "1", "select.wav"),
        ("game.title.3".localized, "game.year.3".localized, "game.description.3".localized, "2", "select.wav"),
        ("game.title.4".localized, "game.year.4".localized, "game.description.4".localized, "3", "select.wav"),
        ("game.title.5".localized, "game.year.5".localized, "game.description.5".localized, "4", "select.wav"),
        ("game.title.6".localized, "game.year.6".localized, "game.description.6".localized, "5", "select.wav"),
        ("game.title.7".localized, "game.year.7".localized, "game.description.7".localized, "6", "select.wav"),
        ("game.title.8".localized, "game.year.8".localized, "game.description.8".localized, "7", "select.wav")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupGestures()
        updateUI()
    }
    
    private func setupUI() {
 
        view.backgroundColor = UIColor(named: "GOWBlack1")
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
        pageControl.addTarget(self, action: #selector(pageControlChanged(_:)), for: .valueChanged)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageControl)

        updatePageControlIndicators()

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

    @objc private func pageControlChanged(_ sender: UIPageControl) {
        currentIndex = sender.currentPage
        updateUI()
        updatePageControlIndicators()
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = pageIndex
        currentIndex = pageIndex
        updateUI()
        updatePageControlIndicators()
    }

    private func updatePageControlIndicators() {
        guard let logoImage = UIImage(named: "gow_logo") else { return }

        for i in 0..<pageControl.numberOfPages {
            if i == pageControl.currentPage {
                pageControl.setIndicatorImage(logoImage, forPage: i)
            } else {
                pageControl.setIndicatorImage(nil, forPage: i)
            }
        }
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
        
        updatePageControlIndicators()
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
