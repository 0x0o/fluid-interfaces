//
//  Rubberbanding.swift
//  FluidInterfaces
//
//  Created by Nathan Gitter on 7/8/18.
//  Copyright © 2018 Nathan Gitter. All rights reserved.
//

import UIKit

class RubberbandingInterfaceViewController: InterfaceViewController {
    
    private let rubberView = RubberView()
    
    private let panRecognier = UIPanGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(rubberView)
        rubberView.center(in: view)
        rubberView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        rubberView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        panRecognier.addTarget(self, action: #selector(panned(recognizer:)))
        rubberView.addGestureRecognizer(panRecognier)
        
    }
    
    private var originalTouchPoint: CGPoint = .zero
    
    @objc private func panned(recognizer: UIPanGestureRecognizer) {
        let touchPoint = recognizer.location(in: view)
        switch recognizer.state {
        case .began:
            originalTouchPoint = touchPoint
        case .changed:
            var offset = touchPoint.y - originalTouchPoint.y
            offset = offset > 0 ? pow(offset, 0.7) : -pow(-offset, 0.7)
            rubberView.transform = CGAffineTransform(translationX: 0, y: offset)
        case .ended, .cancelled:
            let animator = UIViewPropertyAnimator(duration: 0.3, dampingRatio: 0.6, animations: {
                self.rubberView.transform = .identity
            })
            animator.isInterruptible = true
            animator.startAnimation()
        default: break
        }
    }
    
}

class RubberView: UIView {
    
    private lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(hex: 0xFF5B50).cgColor, UIColor(hex: 0xFFC950).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        return gradientLayer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    private func sharedInit() {
        layer.addSublayer(gradientLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.width * 0.2).cgPath
        layer.mask = maskLayer
    }
    
}
