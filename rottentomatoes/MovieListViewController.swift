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

class MovieListViewController: UIViewController {

    var movies: Array<JSON>?
    @IBOutlet weak var movieListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MRProgressOverlayView.showOverlayAddedTo(self.view, animated: true)
        if let config = NSDictionary(contentsOfFile: NSBundle.mainBundle().pathForResource("config", ofType: "plist")!) {
            let ApiKey = config.objectForKey("API_KEY") as String
            let RTBaseURL = "http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json"
            Alamofire.request(.GET, RTBaseURL, parameters: ["apikey": ApiKey, "limit": "50"])
                .responseJSON { (_, _, data, error) in
                    if let data = data {
                        let json = JSON(data)
                        self.movies = json["movies"].arrayValue
                        self.movieListTableView.reloadData()
                    }
                    else if let error = error {
                        // network error
                    }
                    else {
                        // something went wrong
                    }
                    MRProgressOverlayView.dismissOverlayForView(self.view, animated: true)
                }
        }
        else {
            // api key error
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
        MRProgressOverlayView.showOverlayAddedTo(cell, animated: true)

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
            let placeholder = UIImageView()
            let thumbnailURL = NSURL(string: movies[indexPath.row]["posters"]["thumbnail"].stringValue)
            placeholder.setImageWithURL(thumbnailURL)
            let placeholderImage = placeholder.image

            let imageURL = NSURL(string: movies[indexPath.row]["posters"]["thumbnail"].stringValue.stringByReplacingOccurrencesOfString("tmb", withString: "ori"))
            let request = NSURLRequest(URL: imageURL!)
            
            cell.movieThumbnailImageView.setImageWithURLRequest(request, placeholderImage: placeholderImage, success: { (_, _, image) -> Void in
                if let image = image {
                    MRProgressOverlayView.dismissOverlayForView(cell, animated: true)
                }
                
                }, failure: nil)
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
