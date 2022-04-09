//
//  CPKImageView.swift
//  CapturePreventionKitSwift
//
//  Created by hanwe on 2022/04/09.
//

import UIKit
import CoreVideo
import AVFoundation

class CPKImageView: UIView {
    
    // MARK: private property
    
    private lazy var imageLayer: AVSampleBufferDisplayLayer = {
        let layer: AVSampleBufferDisplayLayer = AVSampleBufferDisplayLayer()
        layer.videoGravity = .resizeAspect
        layer.preventsCapture = true
        return layer
    }()
    
    private let queueName: String = "CPKImageViewQueue"
    
    // MARK: internal property
    
    var image: UIImage? {
        didSet {
            guard let img = self.image else { return }
            let queue = DispatchQueue(label: self.queueName)
            queue.async { [weak self] in
                if let video = self?.makeVideoImage(img) {
                    DispatchQueue.main.async { [weak self] in
                        self?.imageLayer.flush()
                        self?.imageLayer.enqueue(video)
                    }
                }
            }
        }
    }
    
//    var contentMode: UIView.ContentMode = .scaleAspectFit
    
    // MARK: lifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // MARK: private function
    
    private func setup() {
        self.layer.addSublayer(self.imageLayer)
        self.imageLayer.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
    }
    
    private func makeVideoImage(_ image: UIImage) -> CMSampleBuffer? {
        guard let cgImage = image.cgImage else { return nil }
        guard let pixcelBuf = CVPixelBufferSupport.pixelBufferCreate(image: cgImage) else { return nil }
        return CMSampleBufferSupport.sampleBufferCreateReady(imageBuffer: pixcelBuf)
    }
    
    // MARK: internal function
    
}
