//
//  CVPixelBufferSupport.swift
//  CapturePreventionKitSwift
//
//  Created by hanwe on 2022/04/06.
//

import UIKit
import CoreVideo
import CoreGraphics

class CVPixelBufferSupport: NSObject {
    
    func pixelBufferCreate(image: CGImage) -> CVPixelBuffer {
        
        let width = image.width
        let height = image.height
        
        var pixelBuffer: CVPixelBuffer!
        let options: [CFString: Any] = [
            kCVPixelBufferCGImageCompatibilityKey: true,
            kCVPixelBufferCGBitmapContextCompatibilityKey: true,
            kCVPixelBufferIOSurfacePropertiesKey: [:]
            ]
        let status = CVPixelBufferCreate(kCFAllocatorDefault,
                                         Int(width),
                                         Int(height),
                                         kCVPixelFormatType_32ARGB,
                                         options as CFDictionary,
                                         &pixelBuffer)
        if status != kCVReturnSuccess {
            print("err")
        }
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let result = CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly)
        
        if result != kCVReturnSuccess {
            print("err")
        }
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
        let context = CGContext.init(data: CVPixelBufferGetBaseAddress(pixelBuffer),
                                     width: width,
                                     height: height,
                                     bitsPerComponent: 8,
                                     bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer),
                                     space: colorSpace,
                                     bitmapInfo: bitmapInfo.rawValue)
        
        context?.draw(image, in: CGRect(x: 0, y: 0, width: width, height: height))
        CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly)
        if (result != kCVReturnSuccess) {
            print("err")
        }
        
        print("pixelBufferCreate end")
        return pixelBuffer
    }

}
