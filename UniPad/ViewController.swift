
import UIKit
import Vision
import VisionKit
import AVFoundation

class ViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    @IBOutlet weak var previewView: UIView!
    
    private var scanButton = ScanButton(frame: .zero)
    private var ocrTextView = OcrTextView(frame: .zero, textContainer: nil)
    private var ocrRequest = VNRecognizeTextRequest(completionHandler: nil)
    
    var captureSession: AVCaptureSession!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        configureOCR()
    }

    
    private func configure() {
        //view.addSubview(scanImageView)
        view.addSubview(ocrTextView)
        view.addSubview(scanButton)
        
        let padding: CGFloat = 16
        NSLayoutConstraint.activate([
            scanButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            scanButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            scanButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            scanButton.heightAnchor.constraint(equalToConstant: 50),
            
            ocrTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            ocrTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            ocrTextView.bottomAnchor.constraint(equalTo: scanButton.topAnchor, constant: -padding),
            ocrTextView.heightAnchor.constraint(equalToConstant: 200),
            
           /* previewView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            previewView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            previewView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            previewView.bottomAnchor.constraint(equalTo: ocrTextView.topAnchor, constant: -padding)*/
        ])
        
        scanButton.addTarget(self, action: #selector(scanDocument), for: .touchUpInside)
    }
    
    
    @objc private func scanDocument() {
        let scanVC = VNDocumentCameraViewController()
        scanVC.delegate = self
        present(scanVC, animated: true)
    }
    
    
    private func processImage(_ image: UIImage) {
        guard let cgImage = image.cgImage else { return }

        ocrTextView.text = ""
        scanButton.isEnabled = false
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            try requestHandler.perform([self.ocrRequest])
        } catch {
            print(error)
        }
    }

    
    private func configureOCR() {
        ocrRequest = VNRecognizeTextRequest { (request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
            
            var ocrText = ""
            for observation in observations {
                guard let topCandidate = observation.topCandidates(1).first else { return }
                
                ocrText += topCandidate.string + "\n"
            }
            
            
            DispatchQueue.main.async {
                self.ocrTextView.text = ocrText
                self.scanButton.isEnabled = true
            }
        }
        
        ocrRequest.recognitionLevel = .accurate
        ocrRequest.recognitionLanguages = ["en-US", "en-GB"]
        ocrRequest.usesLanguageCorrection = true
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
        super.viewDidAppear(animated)
                
                captureSession = AVCaptureSession()
                captureSession.sessionPreset = .medium
                
                guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
                    else {
                        print("Unable to access back camera!")
                        return
                }
                
                do {
                    let input = try AVCaptureDeviceInput(device: backCamera)
            
                    if captureSession.canAddInput(input)
                    {
                        captureSession.addInput(input)
                        setupLivePreview()
                    }
                }
    catch let error  {
        print("Error Unable to initialize back camera:  \(error.localizedDescription)")
    }
          
            
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            self.captureSession.stopRunning()
        }
    
    func setupLivePreview() {
           
           videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
           
           videoPreviewLayer.videoGravity = .resizeAspect
           videoPreviewLayer.connection?.videoOrientation = .portrait
           previewView.layer.addSublayer(videoPreviewLayer)
           
           DispatchQueue.global(qos: .userInitiated).async { //[weak self] in
               self.captureSession.startRunning()
               
               DispatchQueue.main.async {
                   self.videoPreviewLayer.frame = self.previewView.bounds
               }
           }
       }
}


extension ViewController: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        guard scan.pageCount >= 1 else {
            controller.dismiss(animated: true)
            return
        }
        
       // scanImageView.image = scan.imageOfPage(at: 0)
        processImage(scan.imageOfPage(at: 0))
        controller.dismiss(animated: true)
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        //Handle properly error
        controller.dismiss(animated: true)
    }
    
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        controller.dismiss(animated: true)
    }
}
