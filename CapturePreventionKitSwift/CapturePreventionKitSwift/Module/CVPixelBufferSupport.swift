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
        
        let testImg = UIImage(named: "tomato")!.cgImage!
        // Create a Pixel Buffer
        
        let width = testImg.width
        let height = testImg.height
        
        var pixelBuffer: CVPixelBuffer!
//        var pixelBuffer: CVPixelBuffer? = nil
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
//            return status
            print("err")
        }
//        CVPixelBufferRef pixelBuffer = *pixelBufferOut;
        
        
        // Create a Color Space
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
        
        // Lock Pixel Buffer
//        let result = CVPixelBufferLockBaseAddress(pixelBuffer, 0);
        let result = CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly) // 흠...
        
        if result != kCVReturnSuccess {
//            return result;
            print("err")
        }
        
//        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
//        kCGImageAlphaPremultipliedFirst
//
//        guard let context = CGContext.init(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: Int(bitsPerComponent), bytesPerRow: Int(bytesPerRow), space: colorSpace, bitmapInfo: UInt32(bitmapInfo.rawValue)) else {
            // cannot create context - handle error
//        }
//        CVPixelBufferGetBaseAddress
        let context = CGContext.init(data: CVPixelBufferGetBaseAddress(pixelBuffer),
                                     width: width,
                                     height: height,
                                     bitsPerComponent: 8,
                                     bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer),
                                     space: colorSpace,
                                     bitmapInfo: bitmapInfo.rawValue)
        
//        print("context: \(context)")
//        CGContextDrawImage(context, CGRect(x: 0, y: 0, width: width, height: height), image)
        context?.draw(testImg, in: CGRect(x: 0, y: 0, width: width, height: height))
//        context?.draw(image, in: CGRect(x: 0, y: 0, width: 340, height: 356))
        
        
        //        // Draw on Bitmap Context
        //        CGContextRef context = CGBitmapContextCreate(CVPixelBufferGetBaseAddress(pixelBuffer), width, height, 8, CVPixelBufferGetBytesPerRow(pixelBuffer), colorSpace, kCGImageAlphaPremultipliedFirst);
        //        CGContextDrawImage(context, CGRectMake(0, 0, width, height), image);
        //        CGContextRelease(context);
        //
        //        // Release a Color Space
//        CGColorSpaceRelease(colorSpace);
        //
        //        // Unlock Pixel Buffer
//                result = CVPixelBufferUnlockBaseAddress(pixelBuffer, 0)
        CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly)
        if (result != kCVReturnSuccess) {
            //            CVPixelBufferRelease(pixelBuffer);
//            return result;
            print("err")
        }
        
        print("pixelBufferCreate end")
        return pixelBuffer
    }

}
