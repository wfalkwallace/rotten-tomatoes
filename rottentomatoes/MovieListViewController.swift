//
//  MovieListViewController.swift
//  rottentomatoes
//
//  Created by William Falk-Wallace on 2/4/15.
//  Copyright (c) 2015 Falk-Wallace. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON

class MovieListViewController: UITableViewController {

    var movies: Array<JSON> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var configDict: NSDictionary?
        if let configFilepath = NSBundle.mainBundle().pathForResource("config", ofType: "plist") {
            configDict = NSDictionary(contentsOfFile: configFilepath)
        }
        if let config = configDict {
            let ApiKey = config.objectForKey("API_KEY") as String
            let RottenTomatoesURLString = "http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=\(ApiKey)"
            let request = NSURLRequest(URL: NSURL(string: RottenTomatoesURLString)!)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{ (response, data, error) in
                var errorValue: NSError? = nil
                let json = JSON(data: data)
                self.movies = json["movies"].arrayValue
                self.tableView.reloadData()
            })
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
        let thumbnailURL = NSURL(string: self.movies[indexPath.row]["posters"]["thumbnail"].stringValue)
        
        cell.movieTitleLabel.text = title
        cell.movieDescriptionLabel.text = synopsis
        cell.movieDescriptionLabel.numberOfLines = 0
        cell.movieThumbnailImageView.setImageWithURL(thumbnailURL)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("Did tap row: \(indexPath.row)")
    }

}
