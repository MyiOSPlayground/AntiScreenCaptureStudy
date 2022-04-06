//
//  CVPixelBufferSupport.swift
//  CapturePreventionKitSwift
//
//  Created by hanwe on 2022/04/06.
//

import CoreVideo
import CoreGraphics

class CVPixelBufferSupport: NSObject {
    
//    func pixelBufferCreate(image: CGImage, pixcelBuf: CVPixelBuffer?) -> CVReturn {
    func pixelBufferCreate(image: CGImage, pixcelBuf: CVPixelBuffer?) -> CVPixelBuffer {
        // Create a Pixel Buffer
        
        let width = image.width
        let height = image.height
        let type: OSType = kCVPixelFormatType_32ARGB
        
        var pixelBuffer: CVPixelBuffer!
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
             kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue]
        let status = CVPixelBufferCreate(kCFAllocatorDefault,
                                         width,
                                         height,
                                         type,
                                         attrs as CFDictionary,
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
        var result = CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly) // 흠...
        
        if result != kCVReturnSuccess {
//            return result;
            print("err")
        }
        
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
//        guard let context = CGContext.init(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: Int(bitsPerComponent), bytesPerRow: Int(bytesPerRow), space: colorSpace, bitmapInfo: UInt32(bitmapInfo.rawValue)) else {
            // cannot create context - handle error
//        }
        let context = CGContext.init(data: &pixelBuffer, width: width, height: height, bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer), space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        
//        print("context: \(context)")
//        CGContextDrawImage(context, CGRect(x: 0, y: 0, width: width, height: height), image)
        
        
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
//        return kCVReturnSuccess
        return pixelBuffer
    }
    
//    CVReturn __CVPixelBufferCreateWithCGImage(CGImageRef _Nonnull image, CVPixelBufferRef _Nullable * _Nonnull pixelBufferOut) {
//        // Create a Pixel Buffer
//        size_t width = (NSInteger)CGImageGetWidth(image);
//        size_t height = (NSInteger)CGImageGetHeight(image);
//
//        NSDictionary *pixelBufferAttributes = @{
//            (NSString *)kCVPixelBufferCGImageCompatibilityKey: @(YES),
//            (NSString *)kCVPixelBufferCGBitmapContextCompatibilityKey: @(YES),
//            (NSString *)kCVPixelBufferIOSurfacePropertiesKey: @{}
//        };
//
//        CVReturn result = CVPixelBufferCreate(kCFAllocatorDefault, width, height, kCVPixelFormatType_32ARGB, (__bridge CFDictionaryRef)pixelBufferAttributes, pixelBufferOut);
//        if (result != kCVReturnSuccess) {
//            return result;
//        }
//        CVPixelBufferRef pixelBuffer = *pixelBufferOut;
//
//        // Create a Color Space
//        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//
//        // Lock Pixel Buffer
//        result = CVPixelBufferLockBaseAddress(pixelBuffer, 0);
//        if (result != kCVReturnSuccess) {
//            CVPixelBufferRelease(pixelBuffer);
//            return result;
//        }
//
//        // Draw on Bitmap Context
//        CGContextRef context = CGBitmapContextCreate(CVPixelBufferGetBaseAddress(pixelBuffer), width, height, 8, CVPixelBufferGetBytesPerRow(pixelBuffer), colorSpace, kCGImageAlphaPremultipliedFirst);
//        CGContextDrawImage(context, CGRectMake(0, 0, width, height), image);
//        CGContextRelease(context);
//
//        // Release a Color Space
//        CGColorSpaceRelease(colorSpace);
//
//        // Unlock Pixel Buffer
//        result = CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
//        if (result != kCVReturnSuccess) {
//            CVPixelBufferRelease(pixelBuffer);
//            return result;
//        }
//
//        return kCVReturnSuccess;
//    }


}
