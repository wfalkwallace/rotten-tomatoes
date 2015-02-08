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

    var movie: Dictionary<String, JSON>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
        override func loadView() {
            let myView = UIView(frame: CGRectZero)
            myView.backgroundColor = UIColor.greenColor()
            self.view = myView
        }

}

