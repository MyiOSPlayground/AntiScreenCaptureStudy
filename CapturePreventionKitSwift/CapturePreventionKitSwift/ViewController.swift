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
    @IBOutlet weak var testView: UIView!
    @IBOutlet weak var debugImageView: UIImageView!
    
    lazy var myLayer: AVSampleBufferDisplayLayer = {
        let layer: AVSampleBufferDisplayLayer = AVSampleBufferDisplayLayer()
        layer.videoGravity = .resizeAspect
        layer.preventsCapture = true
        return layer
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.testLabel1.text = "hello world"
//        CVPixelBufferRef pixelBuffer
//        let buff: CVPixelBuffer = CVPixelBuffer()
        let test: CVPixelBuffer = CVPixelBufferSupport().pixelBufferCreate(image: UIImage(named: "tomato")!.cgImage!, pixcelBuf: nil)
        print("test: \(test)")
        let test2: CMSampleBuffer = CMSampleBufferSupport().sampleBufferCreateReady(imageBuffer: test)
        print("test2: \(test2)")
        self.testView.layer.addSublayer(myLayer)
        myLayer.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        myLayer.flush()
        myLayer.enqueue(test2)
//        testView.setNeedsDisplay()
        
        // test
        myLayer.flush()
//        myLayer.backgroundColor = UIColor.red.cgColor
        let test3: CMSampleBuffer = UIImage(named: "tomato")!.cmSampleBuffer
//        myLayer.enqueue(test3)
        print("test3: \(test3)")
        
        // test
        
        
        let testBuff = UIImage(named: "tomato")!.cvPixelBuffer!
        
        let imageBuffer = CMSampleBufferGetImageBuffer(test3)!
        let ciimage = CIImage(cvPixelBuffer: imageBuffer)
        let context = CIContext(options: nil)
        let cgImage = context.createCGImage(ciimage, from: ciimage.extent)!
        let image = UIImage(cgImage: cgImage)
        
        self.debugImageView.image = UIImage.init(pixelBuffer: testBuff)
        self.debugImageView.image = UIImage(named: "tomato")
        self.debugImageView.image = image
        self.view.layoutIfNeeded()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
}


import VideoToolbox

extension UIImage {
    public convenience init?(pixelBuffer: CVPixelBuffer) {
        var cgImage: CGImage?
        VTCreateCGImageFromCVPixelBuffer(pixelBuffer, options: nil, imageOut: &cgImage)

        guard let cgImage = cgImage else {
            return nil
        }

        self.init(cgImage: cgImage)
    }
}


extension UIImage {
    var cvPixelBuffer: CVPixelBuffer? {
        var pixelBuffer: CVPixelBuffer? = nil
        let options: [NSObject: Any] = [
            kCVPixelBufferCGImageCompatibilityKey: false,
            kCVPixelBufferCGBitmapContextCompatibilityKey: false,
            ]
        
        _ = CVPixelBufferCreate( kCFAllocatorDefault,
                                          Int(size.width),
                                          Int(size.height),
                                          kCVPixelFormatType_32BGRA,
                                          options as CFDictionary, &pixelBuffer)
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData,
                                width: Int(size.width),
                                height: Int(size.height),
                                bitsPerComponent: 8,
                                bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!),
                                space: rgbColorSpace,
                                bitmapInfo: CGBitmapInfo.byteOrder32Little.rawValue)
        
        context?.draw(cgImage!, in: CGRect(origin: .zero, size: size))
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        return pixelBuffer
    }
        
    var cmSampleBuffer: CMSampleBuffer {
        let pixelBuffer = cvPixelBuffer
        var newSampleBuffer: CMSampleBuffer? = nil
        var timimgInfo: CMSampleTimingInfo = CMSampleTimingInfo.invalid
        var videoInfo: CMVideoFormatDescription? = nil
        CMVideoFormatDescriptionCreateForImageBuffer(allocator: nil,
                                          imageBuffer: pixelBuffer!,
                                          formatDescriptionOut: &videoInfo)
                                          
        CMSampleBufferCreateForImageBuffer(allocator: kCFAllocatorDefault,
                                           imageBuffer: pixelBuffer!,
                                           dataReady: true,
                                           makeDataReadyCallback: nil,
                                           refcon: nil,
                                           formatDescription: videoInfo!,
                                           sampleTiming: &timimgInfo,
                                           sampleBufferOut: &newSampleBuffer)
        return newSampleBuffer!
    }
}
