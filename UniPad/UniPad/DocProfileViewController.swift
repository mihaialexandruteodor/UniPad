//
//  DocProfileViewController.swift
//  UniPad
//
//  Created by teo on 07.09.2020.
//

import UIKit
import Vision
import VisionKit

class DocProfileViewController: UIViewController, VNDocumentCameraViewControllerDelegate  {

    @IBOutlet var docImageView: UIImageView!
    @IBOutlet var docDetailsTextView: UITextView!
    
    var docImage: UIImage!
    var textRecognitionRequest = VNRecognizeTextRequest()
    var recognizedText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.title = "New Document"
        docImageView.image = docImage
        
        textRecognitionRequest = VNRecognizeTextRequest(completionHandler: { (request, error) in
                if let results = request.results, !results.isEmpty {
                    if let requestResults = request.results as? [VNRecognizedTextObservation] {
                        self.recognizedText = ""
                        for observation in requestResults {
                            guard let candidiate = observation.topCandidates(1).first else { return }
                              self.recognizedText += candidiate.string
                            self.recognizedText += "\n"
                        }
                        self.docDetailsTextView.text = self.recognizedText
                    }
                }
        })}
    
    @IBAction func scanDocument(_ sender: Any) {
        let documentCameraViewController = VNDocumentCameraViewController()
         documentCameraViewController.delegate = self
         self.present(documentCameraViewController, animated: true, completion: nil)
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        let image = scan.imageOfPage(at: 0)
            let handler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])
            do {
                try handler.perform([textRecognitionRequest])
            } catch {
                print(error)
            }
            controller.dismiss(animated: true)
    }
    
    
}
