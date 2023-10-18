//
//  Constants.swift
//  drawApp
//
//  Created by sandeep on 2023-10-18.
//

import Foundation
import UIKit
enum DrawingColor {
    case red
    case blue
    case green
    case eraser
    
    var buttonColor: UIColor {
        switch self {
        case .red:
            return .red
        case .blue:
            return .blue
        case .green:
            return .green
        case .eraser:
            return .white
        }
    }
    
var drawingDelay: TimeInterval {
        switch self {
        case .red:
            return 1.0
        case .blue:
            return 3.0
        case .green:
            return 5.0
        case .eraser:
            return 2.0
        }
    }
}

class TopShadowViewClass: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        // Clear background to show shadow effect
        backgroundColor = .clear
        
        // Add shadow layer to create a shadow at the top
        let shadowLayer = CALayer()
        shadowLayer.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: 4)
        shadowLayer.backgroundColor = UIColor.clear.cgColor
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowOffset = CGSize(width: 0, height: 4)
        shadowLayer.shadowRadius = 4
        shadowLayer.shadowOpacity = 0
        
    }
}
