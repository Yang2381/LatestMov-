//
//  MovieViewController.swift
//  Flick
//
//  Created by YangSzu Kai on 2017/1/30.
//  Copyright © 2017年 YangSzu Kai. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD


class MovieViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    
    var movies: [NSDictionary]?  //? means the type could be null if no array of NSDictionary
    var endpoint: String!
    
    
    var curFramePosition: Double!
    var showStatusBar: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
      // navigationController?.hidesBarsOnSwipe = false
        //Tell program that protocol functions is here
        tableView.dataSource = self
        tableView.delegate = self
        loadAPI()
       
    }
       
    /*
        Reload the connection with the api again and reload t
     he data also stop spinning after reload data to tableview
     */
   func refreshControlAction(_ refresh: UIRefreshControl) {
    
    //Adding the progress HUD when load
    let loadingWarning = MBProgressHUD.showAdded(to: self.view, animated: true)
    loadingWarning.mode = MBProgressHUDMode.indeterminate
    loadingWarning.label.text = "Loading"
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    
    let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
   let url = URL(string: "https://api.themoviedb.org/3/movie/\(endpoint!)?api_key=\(apiKey)")!
    let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
    let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
        if let data = data {
            //dataDictionary = the file of json. Its dictionary
            if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
        
                //Hide progress HUD after load
                MBProgressHUD.hide(for: self.view, animated: true)
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                //movies = all of the data after results
                self.movies = dataDictionary["results"] as? [NSDictionary]
                self.tableView.reloadData()
            }
        }
    }
    task.resume()
    
    //Reload the data to the tableview again
    tableView.reloadData()
    
    //Tell the spinning icon to stop spinning
    refresh.endRefreshing()

    }
    
    func loadAPI() {
        
        //Adding the progress HUD when load
        let loadingWarning = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingWarning.mode = MBProgressHUDMode.indeterminate
        loadingWarning.label.text = "Loading"
        
        
        
        //Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        
        //Call the refreshControlAction function when ControlEvents sense value change and start the spinning
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        
        //Set up the URL request
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(endpoint!)?api_key=\(apiKey)")!
        
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        //Setup the session
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        //Make the request
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            guard error == nil else {
                
                let alert = UIAlertController(title: " Error", message: "No internet connection", preferredStyle: .alert )
                self.present(alert, animated: true, completion: nil)
                let OKAction = UIAlertAction(title: "OK", style: .default){(action:UIAlertAction) in
                    print("OK");
                    return
                }
                alert.addAction(OKAction)
                return
            }
            
            
            if let data = data {
                //dataDictionary = the file of json. Its dictionary
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    //print(dataDictionary)
                    
                    //Hide progress HUD after load
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                    //movies = all of the data after results
                    self.movies = dataDictionary["results"] as? [NSDictionary]
                    self.tableView.reloadData()
                }
            }
            //Add spinning icon to the table view
            self.tableView.insertSubview(refreshControl, at: 0)
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
        let baseURL = "https://image.tmdb.org/t/p/w500"
       
        if let posterPath = movie["poster_path"] as? String{
        let imageUrl = NSURL(string: baseURL+posterPath)
        cell.moviePoster.setImageWith(imageUrl as! URL)
        }
                
        cell.TitleLabel.text = title
        cell.overviewLabel.text = overview
        
        
        
        return cell
    }
    
    
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    /*
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       navigationController?.barHideOnSwipeGestureRecognizer
    
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
        let movie = movies![indexPath!.row]
        
        let detailViewController = segue.destination as! DetailViewController
        detailViewController.movie = movie
    }

}
