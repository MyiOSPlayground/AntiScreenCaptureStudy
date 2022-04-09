//
//  CMSampleBufferSupport.swift
//  CapturePreventionKitSwift
//
//  Created by hanwe on 2022/04/06.
//

import UIKit
import CoreMedia
import CoreVideo

class CMSampleBufferSupport: NSObject {
    func sampleBufferCreateReady(imageBuffer: CVImageBuffer) -> CMSampleBuffer {
        var buffer: CMSampleBuffer!
        var formatDescription: CMVideoFormatDescription!
        var status = CMVideoFormatDescriptionCreateForImageBuffer(allocator: kCFAllocatorDefault,
                                                                  imageBuffer: imageBuffer,
                                                                  formatDescriptionOut: &formatDescription)
        if (status != 0) {
            print("err")
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
            print("err")
        }
        
        return buffer
    }

}
