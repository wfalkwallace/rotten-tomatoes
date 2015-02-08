//
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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
        override func loadView() {
            let movie = JSON(movieData!)
            let view = UIView(frame: CGRectZero)
            view.backgroundColor = UIColor.blueColor()
            
            let descriptionView = UIView(frame: CGRectZero)
            descriptionView.backgroundColor = UIColor.greenColor()
//            descriptionView.frame.size.height = CGRectZero.size.height/2
//            descriptionView.frame.origin.x = CGRectZero.size.height/2
            let titleLabel = UILabel(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
            titleLabel.text = movie["title"].stringValue
            
            let posterImageView = UIImageView(frame: CGRectZero)
            let posterURL = NSURL(string: movie["posters"]["profile"].stringValue.stringByReplacingOccurrencesOfString("tmb", withString: "ori"))
            posterImageView.setImageWithURL(posterURL, placeholderImage: UIImage(named: "logo-fresh"))

            self.view.addSubview(posterImageView)
            self.view.addSubview(descriptionView)
            self.view = view


        }

}

