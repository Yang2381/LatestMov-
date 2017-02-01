//
//  MovieViewController.swift
//  Flick
//
//  Created by YangSzu Kai on 2017/1/30.
//  Copyright © 2017年 YangSzu Kai. All rights reserved.
//

import UIKit
import AFNetworking

class MovieViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var movies: [NSDictionary]?  //? means the type could be null if no array of NSDictionary
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Tell program that protocol functions is here
        tableView.dataSource = self
        tableView.delegate = self
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data {
                //dataDictionary = the file of json. Its dictionary
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    print(dataDictionary)
                    //movies = all of the data after results
                    self.movies = dataDictionary["results"] as? [NSDictionary]
                    self.tableView.reloadData()
                }
            }
        }
        task.resume()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Tells tableview how many cells will there be
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        //means there will be 20 rows/cells
        
        if let movies = movies {
            return movies.count
            
        }else{
            return 0
        }
        
    }
    
    
    //Communicate and set the content of each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        //indexpath tells where the cell will be in the tableview 
        
        //movie = array of each cell in the result of all data store in result
        let movie = movies![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        let posterPath = movie["poster_path"] as! String
        
        let baseURL = "https://image.tmdb.org/t/p/w500"
        
        let imageUrl = NSURL(string: baseURL+posterPath)
                
        cell.TitleLabel.text = title
        cell.overviewLabel.text = overview
        cell.moviePoster.setImageWith(imageUrl as! URL)
        
        
        return cell
    }

}
