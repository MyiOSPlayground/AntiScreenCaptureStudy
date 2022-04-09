//
//  CPKCoreLabel.swift
//  CapturePreventionKitSwift
//
//  Created by hanwe on 2022/04/10.
//

import UIKit

protocol CPKCoreLabelDelegate: AnyObject {
    func drawCPKCoreLabel(_ rect: CGRect)
}

class CPKCoreLabel: UILabel {

    weak var delegate: CPKCoreLabelDelegate?
    
    override func draw(_ rect: CGRect) {
        self.delegate?.drawCPKCoreLabel(rect)
    }

}
