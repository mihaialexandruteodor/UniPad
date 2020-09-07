//
//  CatProfileViewController.swift
//  Snapcat
//
//  Created by Sai Kambampati on 8/21/19.
//  Copyright © 2019 AppCoda. All rights reserved.
//

import UIKit

class CatProfileViewController: UIViewController {

    @IBOutlet var catImageView: UIImageView!
    @IBOutlet var catDetailsTextView: UITextView!
    
    var catImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.title = "New Cat"
        catImageView.image = catImage
    }
    
    @IBAction func scanDocument(_ sender: Any) {
        // Use VisionKit to scan business cards
    }
    
}
