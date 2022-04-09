//
//  CMSampleBufferSupport.swift
//  CapturePreventionKitSwift
//
//  Created by hanwe on 2022/04/06.
//

import CoreMedia
import CoreVideo

class CMSampleBufferSupport: NSObject {
    
    static func sampleBufferCreateReady(imageBuffer: CVImageBuffer) -> CMSampleBuffer? {
        var buffer: CMSampleBuffer?
        var formatDescriptionPtr: CMVideoFormatDescription?
        var status = CMVideoFormatDescriptionCreateForImageBuffer(allocator: kCFAllocatorDefault,
                                                                  imageBuffer: imageBuffer,
                                                                  formatDescriptionOut: &formatDescriptionPtr)
        guard let formatDescription = formatDescriptionPtr else { return nil }
        if (status != 0) {
            print("capturePrevention Error: \(status)")
            return nil
        }
        
        var timingInfo: CMSampleTimingInfo = CMSampleTimingInfo(duration: CMTime.zero,
                                                                presentationTimeStamp: CMTime.zero,
                                                                decodeTimeStamp: CMTime.invalid)
        status = CMSampleBufferCreateReadyWithImageBuffer(allocator: kCFAllocatorDefault,
                                                          imageBuffer: imageBuffer,
                                                          formatDescription: formatDescription,
                                                          sampleTiming: &timingInfo,
                                                          sampleBufferOut: &buffer)
        
        if (status != 0) {
            print("capturePrevention Error: \(status)")
            return nil
        }
        
        return buffer
    }

}
