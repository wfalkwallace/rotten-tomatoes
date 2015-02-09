//  MovieDetailViewController.swift
//  rottentomatoes
//
//  Created by William Falk-Wallace on 2/7/15.
//  Copyright (c) 2015 Falk-Wallace. All rights reserved.
//

import Alamofire
import Foundation
import SwiftyJSON
import UIKit

class MovieDetailViewController: UIViewController {

    var movieData: AnyObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let windowWidth = self.view.frame.width;
        let windowHeight = self.view.frame.height;
        
        let movie = JSON(movieData!)
        let view = UIView(frame: CGRect(x: 0, y: 0, width: windowWidth, height: windowHeight))
        view.backgroundColor = UIColor(red: 40, green: 55, blue: 75, alpha: 1)
        
        let descriptionView = UIScrollView(frame: CGRect(x: 0, y: windowHeight * 0.6, width: windowWidth, height: windowHeight * 0.4))
        descriptionView.showsVerticalScrollIndicator=true;
        descriptionView.scrollEnabled=true;
        descriptionView.userInteractionEnabled=true;
        descriptionView.backgroundColor = UIColor(red:0.27, green:0.31, blue:0.38, alpha:0.86)
        
        let titleLabel = UILabel(frame: CGRect(x: 8, y: 8, width: windowWidth - 16, height: 25))
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.text = movie["title"].stringValue
        titleLabel.font = UIFont(name: "Helvetica-BoldOblique", size: 20.0)
        descriptionView.addSubview(titleLabel)
        
        let descriptionLabel = UILabel(frame: CGRect(x: 8, y: 41, width: windowWidth - 16, height: 0))
        descriptionLabel.textColor = UIColor.whiteColor()
        descriptionLabel.text = movie["synopsis"].stringValue
        descriptionLabel.numberOfLines = 0
        descriptionLabel.sizeToFit()
        descriptionView.addSubview(descriptionLabel)
        
        descriptionView.contentSize = CGSizeMake(windowWidth - 16, descriptionLabel.frame.size.height + 49)

        // Image Stuff
        let posterImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: windowWidth, height: windowHeight))
        
        let thumbnailURLRequest = NSURLRequest(URL: NSURL(string: movie["posters"]["profile"].stringValue)!)
        let thumbnailHighResURLRequest = NSURLRequest(URL: NSURL(string: movie["posters"]["profile"].stringValue.stringByReplacingOccurrencesOfString("tmb", withString: "ori"))!)
        let placeholder = UIImage(named: "Image-Placeholder")
        
        posterImageView.setImageWithURLRequest(thumbnailURLRequest, placeholderImage: placeholder, success: { (_, _, image) -> Void in
            posterImageView.setImageWithURLRequest(thumbnailHighResURLRequest, placeholderImage: image, success: { (_, _, image) -> Void in
                posterImageView.alpha = 0.0;
                posterImageView.image = image;
                UIView.animateWithDuration(0.5, animations: {
                    posterImageView.alpha = 1.0
                })
            }, failure: nil)
        }, failure: nil)

        view.addSubview(posterImageView)
        view.addSubview(descriptionView)
        self.view = view
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

