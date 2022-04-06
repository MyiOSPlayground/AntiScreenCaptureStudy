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
    
    @IBOutlet weak var testLabel1: UILabel!
    
    lazy var myLayer: AVSampleBufferDisplayLayer = {
        let layer: AVSampleBufferDisplayLayer = AVSampleBufferDisplayLayer()
        return layer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.testLabel1.text = "hello world"
//        CVPixelBufferRef pixelBuffer
//        let buff: CVPixelBuffer = CVPixelBuffer()
        let test: CVPixelBuffer = CVPixelBufferSupport().pixelBufferCreate(image: UIImage(named: "tomato")!.cgImage!, pixcelBuf: nil)
        print("test: \(test)")
        let test2: CMSampleBuffer = CMSampleBufferSupport().sampleBufferCreateReady(imageBuffer: test)
        print("test2: \(test2)")
    }
}
