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
        layer.speed = 999
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
    
    override var contentMode: UIView.ContentMode {
        didSet {
            switch self.contentMode {
            case .scaleToFill:
                self.imageLayer.videoGravity = .resize
            case .scaleAspectFit:
                self.imageLayer.videoGravity = .resizeAspect
            case .scaleAspectFill:
                self.imageLayer.videoGravity = .resizeAspectFill
            case .redraw:
                self.imageLayer.videoGravity = .resize
            case .center:
                self.imageLayer.videoGravity = .resize
            case .top:
                self.imageLayer.videoGravity = .resize
            case .bottom:
                self.imageLayer.videoGravity = .resize
            case .left:
                self.imageLayer.videoGravity = .resize
            case .right:
                self.imageLayer.videoGravity = .resize
            case .topLeft:
                self.imageLayer.videoGravity = .resize
            case .topRight:
                self.imageLayer.videoGravity = .resize
            case .bottomLeft:
                self.imageLayer.videoGravity = .resize
            case .bottomRight:
                self.imageLayer.videoGravity = .resize
            @unknown default:
                self.imageLayer.videoGravity = .resize
            }
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
