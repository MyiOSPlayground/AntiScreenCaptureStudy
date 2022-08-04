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
    
    private lazy var coreLabel: CPKCoreLabel = {
        let label: CPKCoreLabel = CPKCoreLabel()
        label.textColor = self.textColor
        label.backgroundColor = self.backgroundColor
        label.numberOfLines = Int(self.numberOfLines)
        label.textAlignment = self.textAlignment
        label.font = self.font
        label.sizeToFit()
        return label
    }()
    
    // MARK: internal property
    
    var text: String = "" {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.calcFrame()
                self?.coreLabel.text = self?.text ?? ""
            }
        }
    }
    
    var textColor: UIColor = .black {
        didSet {
            self.coreLabel.textColor = self.textColor
        }
    }
    
    var font: UIFont = .systemFont(ofSize: 20) {
        didSet {
            self.coreLabel.font = self.font
        }
    }
    
    var textAlignment: NSTextAlignment = .left {
        didSet {
            self.coreLabel.textAlignment = self.textAlignment
        }
    }
    
    var numberOfLines: UInt = 1 {
        didSet {
            self.coreLabel.numberOfLines = Int(self.numberOfLines)
        }
    }
    
    var attributedText: NSAttributedString? {
        didSet {
            self.coreLabel.attributedText = self.attributedText
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
        self.layer.addSublayer(self.labelLayer)
        self.labelLayer.frame = self.coreLabel.frame
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
        self.labelLayer.frame = self.coreLabel.frame
    }
    
    private func updateTest() {
        self.coreLabel.isHidden = false
        let imageRender = UIGraphicsImageRenderer(bounds: self.coreLabel.frame)
        let image = imageRender.image { context in
            self.coreLabel.layer.render(in: context.cgContext)
        }
        guard let video = makeVideoImage(image) else { return }
        self.coreLabel.isHidden = true
        DispatchQueue.main.async { [weak self] in
            self?.labelLayer.flush()
            self?.labelLayer.enqueue(video)
        }
    }
    
    // MARK: internal function
    
    func drawCPKCoreLabel(_ rect: CGRect) {
        updateTest()
    }
}
