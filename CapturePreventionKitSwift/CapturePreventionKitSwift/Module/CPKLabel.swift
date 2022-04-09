//
//  CPKLabel.swift
//  CapturePreventionKitSwift
//
//  Created by hanwe on 2022/04/10.
//

import UIKit
import CoreVideo
import AVFoundation

class CPKLabel: UIView, CPKCoreLabelDelegate {
    
    // MARK: private property
    
    private lazy var labelLayer: AVSampleBufferDisplayLayer = {
        let layer: AVSampleBufferDisplayLayer = AVSampleBufferDisplayLayer()
        layer.videoGravity = .resizeAspect
        layer.preventsCapture = true
        layer.speed = 999
        return layer
    }()
    
    private let queueName: String = "CPKLabelViewQueue"
    
    private let coreLabel: CPKCoreLabel = {
        let label: CPKCoreLabel = CPKCoreLabel()
        return label
    }()
    
    // MARK: internal property
    
    var image: UIImage? {
        didSet {
            guard let img = self.image else { return }
            let queue = DispatchQueue(label: self.queueName)
            queue.async { [weak self] in
                if let video = self?.makeVideoImage(img) {
                    DispatchQueue.main.async { [weak self] in
                        self?.labelLayer.flush()
                        self?.labelLayer.enqueue(video)
                    }
                }
            }
        }
    }
    
    var text: String = "" {
        didSet {
            
        }
    }
    
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
        self.layer.addSublayer(self.labelLayer)
        self.labelLayer.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        self.coreLabel.delegate = self
    }
    
    private func makeVideoImage(_ image: UIImage) -> CMSampleBuffer? {
        guard let cgImage = image.cgImage else { return nil }
        guard let pixcelBuf = CVPixelBufferSupport.pixelBufferCreate(image: cgImage) else { return nil }
        return CMSampleBufferSupport.sampleBufferCreateReady(imageBuffer: pixcelBuf)
    }
    
    // MARK: internal function
    
    func drawCPKCoreLabel(_ rect: CGRect) {
        
    }

}
