//
//  ViewController.swift
//  UniPad
//
//  Created by teo on 07.09.2020.
//

import UIKit
import ARKit


class ViewController: UIViewController {
    
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
        let vc = self.storyboard?.instantiateViewController(identifier: "Profile") as! DocProfileViewController
        vc.docImage = currentFrame
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ViewController: ARSCNViewDelegate {
    
}
