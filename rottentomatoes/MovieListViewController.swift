//
//  MovieListViewController.swift
//  rottentomatoes
//
//  Created by William Falk-Wallace on 2/4/15.
//  Copyright (c) 2015 Falk-Wallace. All rights reserved.
//

import Alamofire
import Foundation
import MRProgress
import SwiftyJSON
import UIKit

class MovieListViewController: UITableViewController {

    var movies: Array<JSON> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let config = NSDictionary(contentsOfFile: NSBundle.mainBundle().pathForResource("config", ofType: "plist")!) {
            let ApiKey = config.objectForKey("API_KEY") as String
            let RTBaseURL = "http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json"
            MRProgressOverlayView.showOverlayAddedTo(self.view, animated: true)
            Alamofire.request(.GET, RTBaseURL, parameters: ["apikey": ApiKey])
                .responseJSON { (_, reponse, data, error) in
                    println("response: \(reponse)")
                    println("data: \(data)")
                    println("error: \(error)")
//                    let json = JSON(data: data!)
//                    self.movies = json["movies"].arrayValue
                    self.tableView.reloadData()
                    MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
            }
        }
        else {
//            network error
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("com.falk-wallace.MovieTableCell") as MovieListTableViewCell

        let title = self.movies[indexPath.row]["title"].stringValue
        let synopsis = self.movies[indexPath.row]["synopsis"].stringValue
        let thumbnailURL = NSURL(string: self.movies[indexPath.row]["posters"]["thumbnail"].stringValue.stringByReplacingOccurrencesOfString("tmb", withString: "ori"))
        
        cell.movieTitleLabel.text = title
        cell.movieTitleLabel.numberOfLines = 0
        cell.movieThumbnailImageView.setImageWithURL(thumbnailURL)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("Did tap row: \(indexPath.row)")
    }

}
