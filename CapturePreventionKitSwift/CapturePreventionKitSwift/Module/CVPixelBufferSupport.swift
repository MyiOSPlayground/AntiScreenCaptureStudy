//
//  CVPixelBufferSupport.swift
//  CapturePreventionKitSwift
//
//  Created by hanwe on 2022/04/06.
//

import CoreVideo
import CoreGraphics

class CVPixelBufferSupport: NSObject {
    
    static func pixelBufferCreate(image: CGImage) -> CVPixelBuffer? {
        
        let width = image.width
        let height = image.height
        
        var pixelBufferPtr: CVPixelBuffer?
        let options: [CFString: Any] = [
            kCVPixelBufferCGImageCompatibilityKey: true,
            kCVPixelBufferCGBitmapContextCompatibilityKey: true,
            kCVPixelBufferIOSurfacePropertiesKey: [:]
            ]
        
        var status = CVPixelBufferCreate(kCFAllocatorDefault,
                                         Int(width),
                                         Int(height),
                                         kCVPixelFormatType_32ARGB,
                                         options as CFDictionary,
                                         &pixelBufferPtr)
        if status != kCVReturnSuccess {
            print("capturePrevention Error: \(status)")
            return nil
        }
        guard let pixelBuffer = pixelBufferPtr else { return nil }

        status = CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly)
        if status != kCVReturnSuccess {
            print("capturePrevention Error: \(status)")
            return nil
        }
        
        let context = CGContext.init(data: CVPixelBufferGetBaseAddress(pixelBuffer),
                                     width: width,
                                     height: height,
                                     bitsPerComponent: 8,
                                     bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer),
                                     space: CGColorSpaceCreateDeviceRGB(),
                                     bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)
        context?.draw(image, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        status = CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly)
        if status != kCVReturnSuccess {
            print("capturePrevention Error: \(status)")
            return nil
        }
        
        return pixelBuffer
    }

}
