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

class MovieListViewController: UIViewController, UITabBarDelegate {

    var movies: Array<JSON>?
    var ApiKey: String?
    let RTDVDBaseURL = "http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json"
    let RTBoxOfficeBaseURL = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json"
    var refreshControl: UIRefreshControl!
    
    @IBOutlet weak var movieListTableView: UITableView!
    @IBOutlet weak var movieListTabBar: UITabBar!
    @IBOutlet weak var networkErrorBarView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var defaults = NSUserDefaults.standardUserDefaults()
        ApiKey = defaults.stringForKey("apikey")
        loadResults()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        movieListTableView.insertSubview(refreshControl, atIndex: 0)
    }

    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
        loadResults(item.title!)
    }
    
    func onRefresh() {
        loadResults()
        self.refreshControl.endRefreshing()
    }
    
    func loadResults() {
        if let tab = movieListTabBar.selectedItem {
            loadResults(tab.title!)
        }
        else {
            loadResults("DVDs")
        }
        
    }
    
    func loadResults(tab: String) {
        MRProgressOverlayView.showOverlayAddedTo(self.view, animated: true)
        var RTBaseURL = (tab == "Box Office") ? RTBoxOfficeBaseURL : RTDVDBaseURL
        if let key = ApiKey {
            Alamofire.request(.GET, RTBaseURL, parameters: ["apikey": key, "limit": "20"])
                .responseJSON { (_, _, data, error) in
                    if let error = error {
                        // network error (first because sometimes you get error and data)
                        self.networkErrorBarView.hidden = false
                    }
                    else if let data = data {
                        self.networkErrorBarView.hidden = true
                        let json = JSON(data)
                        self.movies = json["movies"].arrayValue
                        self.movieListTableView.reloadData()
                    }
                    else {
                        // something went wrong
                    }
                    MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
                }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = self.movies {
            return movies.count
        }
        else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("com.falk-wallace.MovieTableCell") as MovieListTableViewCell
        cell.movieThumbnailImageView.image = nil;
        
        if let movies = self.movies {
            // List Title
            let title = movies[indexPath.row]["title"].stringValue
            cell.movieTitleLabel.text = title
            cell.movieDescriptionLabel.numberOfLines = 0

            // List Rating
            let rating = "(" + movies[indexPath.row]["mpaa_rating"].stringValue + ")"
            cell.movieRatingLabel.text = rating

            // List Description
            let synopsis = movies[indexPath.row]["synopsis"].stringValue
            cell.movieDescriptionLabel.text = synopsis
            cell.movieDescriptionLabel.numberOfLines = 0
            
            // List Thumbnail
            let thumbnailURL = NSURL(string: movies[indexPath.row]["posters"]["thumbnail"].stringValue)
            cell.movieThumbnailImageView.setImageWithURL(thumbnailURL)
                
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailView = MovieDetailViewController()
        if let movies = self.movies {
            let movie = movies[indexPath.row]
            detailView.movieData = movie.object
            self.navigationController?.pushViewController(detailView, animated: true)
        }
    }

}
