//
//  CameraViewController.swift
//  Snapcat
//
//  Created by Sai Kambampati on 8/21/19.
//  Copyright © 2019 AppCoda. All rights reserved.
//

import UIKit
import ARKit

class CameraViewController: UIViewController {
    
    @IBOutlet var previewView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        previewView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        previewView.session.run(configuration)
    }

    @IBAction func snap(_ sender: Any) {
        let currentFrame = previewView.snapshot()
        let vc = self.storyboard?.instantiateViewController(identifier: "Profile") as! CatProfileViewController
        vc.catImage = currentFrame
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension CameraViewController: ARSCNViewDelegate {
    
}
