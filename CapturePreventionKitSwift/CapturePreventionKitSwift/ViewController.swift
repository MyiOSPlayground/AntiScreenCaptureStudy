//
//  ViewController.swift
//  CapturePreventionKitSwift
//
//  Created by hanwe on 2022/04/06.
//

import UIKit
import CoreVideo
import AVFoundation


class ViewController: UIViewController {
    
    @IBOutlet weak var testImgView: UIImageView!
    @IBOutlet weak var testLabel1: UILabel!
    @IBOutlet weak var testView: UIView!
    @IBOutlet weak var customImgView: CPKImageView!
    
    lazy var myLayer: AVSampleBufferDisplayLayer = {
        let layer: AVSampleBufferDisplayLayer = AVSampleBufferDisplayLayer()
        layer.videoGravity = .resizeAspect
        layer.preventsCapture = true
        return layer
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.testLabel1.text = "hello world"
        let test: CVPixelBuffer? = CVPixelBufferSupport.pixelBufferCreate(image: UIImage(named: "tomato")!.cgImage!)
        let test2: CMSampleBuffer? = CMSampleBufferSupport.sampleBufferCreateReady(imageBuffer: test!)
        self.testView.layer.addSublayer(myLayer)
        myLayer.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        myLayer.flush()
        myLayer.enqueue(test2!)
        self.testImgView.contentMode = .scaleToFill
        self.customImgView.contentMode = .scaleAspectFit
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customImgView.image = UIImage(named: "tomato")

    }
    
    @IBAction func testAction(_ sender: Any) {
        self.customImgView.image = UIImage(named: "carrot")
    }
    
}
