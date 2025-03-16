//
//  GamesViewController.swift
//  GOW
//
//  Created by Rafael Gonzalez on 07/03/25.
//

import UIKit

class GamesViewController: UIViewController {
    @IBOutlet weak var gameImage: UIImageView!
    
    @IBOutlet var rigthSwipeDone: UISwipeGestureRecognizer!
    @IBOutlet weak var imagePageControl: UIPageControl!
    
    @IBAction func rigthSwipeDoneAction(_ sender: UISwipeGestureRecognizer) {
        print("Right swipe")
        // Do any additional setup after loading the view.
        var index = imagePageControl.currentPage;
        index = index + 1;
        if index <= 7{
            gameImage.image = UIImage(named: String(gamePosters[index]))
        }
        else{
            index = 0;
            gameImage.image = UIImage(named: String(gamePosters[index]))
        }
        imagePageControl.currentPage = index;
        
    }
    
    @IBAction func leftSwipeDoneAction(_ sender: Any) {
        print ("Left swipe")
        var index = imagePageControl.currentPage;
        index = index - 1;
        if index <= 0{
            index = 7;
            gameImage.image = UIImage(named: String(gamePosters[index]))
        }
        else{
            
            gameImage.image = UIImage(named: String(gamePosters[index]))
        }
        imagePageControl.currentPage = index;
    }
    
    
    //datasource :P
    let gamePosters = Array(0...7)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imagePageControl.numberOfPages = gamePosters.count
        gameImage.image = UIImage(named: gamePosters.first?.description ?? "0")
    }
}
