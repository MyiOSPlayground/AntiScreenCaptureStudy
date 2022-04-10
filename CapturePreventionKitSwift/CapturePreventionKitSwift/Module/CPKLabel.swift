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
    
//    private lazy var labelLayer: AVSampleBufferDisplayLayer = {
//        let layer: AVSampleBufferDisplayLayer = AVSampleBufferDisplayLayer()
//        layer.videoGravity = .resizeAspect
//        layer.preventsCapture = true
//        layer.speed = 999
//        return layer
//    }()
    
    private let queueName: String = "CPKLabelViewQueue"
    
    private let coreLabel: CPKCoreLabel = {
        let label: CPKCoreLabel = CPKCoreLabel()
        label.textColor = .black
        label.backgroundColor = .lightGray
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 20)
        label.sizeToFit()
        return label
    }()
    
    // MARK: internal property
    
//    var image: UIImage? {
//        didSet {
//            guard let img = self.image else { return }
//            let queue = DispatchQueue(label: self.queueName)
//            queue.async { [weak self] in
//                if let video = self?.makeVideoImage(img) {
//                    DispatchQueue.main.async { [weak self] in
//                        self?.labelLayer.flush()
//                        self?.labelLayer.enqueue(video)
//                    }
//                }
//            }
//        }
//    }
    
    var text: String = "" {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.calcFrame()
                self?.coreLabel.text = self?.text ?? ""
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: private function
    
    private func setup() {
//        self.layer.addSublayer(self.labelLayer)
//        self.labelLayer.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        self.coreLabel.delegate = self
        self.addSubview(self.coreLabel)
    }
    
    private func makeVideoImage(_ image: UIImage) -> CMSampleBuffer? {
        guard let cgImage = image.cgImage else { return nil }
        guard let pixcelBuf = CVPixelBufferSupport.pixelBufferCreate(image: cgImage) else { return nil }
        return CMSampleBufferSupport.sampleBufferCreateReady(imageBuffer: pixcelBuf)
    }
    
    private func calcFrame() {
        let textRect: CGRect = self.coreLabel.textRect(forBounds: self.bounds, limitedToNumberOfLines: self.coreLabel.numberOfLines)
        let x: CGFloat = textRect.minX
        let y: CGFloat = textRect.minY
        let width: CGFloat = textRect.width
        let height: CGFloat = textRect.height
        let frame = CGRect(x: x, y: y, width: width, height: height)
        self.coreLabel.frame = frame
    }
    
    // MARK: internal function
    
    func drawCPKCoreLabel(_ rect: CGRect) {
        print("test: \(self.coreLabel.text)")
    }
}
