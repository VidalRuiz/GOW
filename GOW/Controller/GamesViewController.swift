import UIKit

class GamesViewController: UIViewController {
    
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var imagePageControl: UIPageControl!
    
    // Data source for game images
    let gamePosters = Array(0...7) // Image indexes corresponding to assets
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the UIPageControl with the number of images available
        imagePageControl.numberOfPages = gamePosters.count
        
        // Set the initial game image
        gameImage.image = UIImage(named: gamePosters.first?.description ?? "0")
        
        // Configure swipe gestures programmatically
        configureSwipeGestures()
    }
    
    /// Configures left and right swipe gestures for image navigation
    private func configureSwipeGestures() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
    }
    
    /// Handles swipe gestures to navigate through game posters
    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        var index = imagePageControl.currentPage
        
        if gesture.direction == .right {
            index = (index + 1) % gamePosters.count
        } else if gesture.direction == .left {
            index = (index - 1 + gamePosters.count) % gamePosters.count
        }
        
        // Update the displayed image and page control indicator
        gameImage.image = UIImage(named: String(gamePosters[index]))
        imagePageControl.currentPage = index
    }
}
