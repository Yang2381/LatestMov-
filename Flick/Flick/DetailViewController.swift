//
//  DetailViewController.swift
//  Flick
//
//  Created by YangSzu Kai on 2017/2/7.
//  Copyright © 2017年 YangSzu Kai. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var Overview: UILabel!
    @IBOutlet weak var PosterImageView: UIImageView!
    
    var movie : NSDictionary?
    var refreshControl : UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let title = movie?["title"] as? String
        titleLabel.text = title
        let overview = movie?["overview"] as? String
        Overview.text = overview
        let posterPath = movie?["poster_path"] as! String
        
        let baseURL = "https://image.tmdb.org/t/p/w500"
        let imageURL = NSURL(string: baseURL + posterPath)
        
        PosterImageView.setImageWith(imageURL as! URL)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    

}
