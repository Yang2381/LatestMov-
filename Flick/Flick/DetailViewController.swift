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
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var infoView: UIView!
    
    
    var movie : NSDictionary?
    var refreshControl : UIRefreshControl!
    var showTATview = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Heigh = start of info view to the bottom of infoview
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y+infoView.frame.size.height)
        
        let title = movie?["title"] as? String
        titleLabel.text = title
        
        let overview = movie?["overview"] as? String
        Overview.text = overview
        Overview.sizeToFit()
        
        let baseURL = "https://image.tmdb.org/t/p/w500"
        
        //Safer act if poster path is not there
        if let posterPath = movie?["poster_path"] as? String{
            let imageUrl = NSURL(string: baseURL+posterPath)
            PosterImageView.setImageWith(imageUrl as! URL)
            
        }
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    

}
