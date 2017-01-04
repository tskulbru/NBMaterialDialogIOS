//
//  NBMaterialCircularActivityIndicator.swift
//  NBMaterialDialogIOS
//
//  Created by Torstein Skulbru on 02/05/15.
//  Copyright (c) 2015 Torstein Skulbru. All rights reserved.
//
// The MIT License (MIT)
//
// Copyright (c) 2015 Torstein Skulbru
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the "Software"), to deal in
// the Software without restriction, including without limitation the rights to
// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
// the Software, and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

@objc open class NBMaterialCircularActivityIndicator : UIView {
    // MARK: - Field Vars
    fileprivate var _progressLayer: CAShapeLayer!
    fileprivate var _isAnimating: Bool = false
    fileprivate var _hidesWhenStopped: Bool = false
    fileprivate var _timingFunction: CAMediaTimingFunction!

    // MARK; - Properties
    internal var progressLayer: CAShapeLayer {
        if _progressLayer == nil {
            _progressLayer = CAShapeLayer()
            _progressLayer.strokeColor = tintColor.cgColor
            _progressLayer.fillColor = nil
            _progressLayer.lineWidth = 3.0
        }

        return _progressLayer
    }

    open var isAnimating: Bool {
        return _isAnimating
    }

    /**
    Defines the thickness of the indicator. Change this to make the circular indicator larger
    */
    open var lineWidth: CGFloat {
        get {
            return progressLayer.lineWidth
        }
        set {
            progressLayer.lineWidth = newValue
            updatePath()
        }
    }

    /**
    Defines if the indicator should be hidden when its stopped (usually yes).
    */
    open var hidesWhenStopped: Bool {
        get {
            return _hidesWhenStopped
        }
        set {
            _hidesWhenStopped = newValue
            isHidden = !isAnimating && _hidesWhenStopped
        }
    }

    open var indicatorColor: UIColor {
        get {
            return tintColor
        }
        set {
            tintColor = newValue
        }
    }

    // MARK: - Constants
    internal let kNBCircleStrokeAnimationKey: String = "nbmaterialcircularactivityindicator.stroke"
    internal let kNBCircleRotationAnimationKey: String = "nbmaterialcircularactivityindicator.rotation"

    // MARK: (de)Initializers
    public override init(frame: CGRect) {
        super.init(frame: frame)

        initialize()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        initialize()
    }

    internal func initialize() {
        tintColor = NBConfig.AccentColor

        _timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)

        layer.addSublayer(progressLayer)

        NotificationCenter.default.addObserver(self, selector: #selector(NBMaterialCircularActivityIndicator.resetAnimations), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }

    // MARK:  UIView overrides
    open override func layoutSubviews() {
        super.layoutSubviews()

        progressLayer.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        updatePath()
    }

    open override func tintColorDidChange() {
        super.tintColorDidChange()

        progressLayer.strokeColor = tintColor.cgColor
    }

    // MARK: Animation functions
    /**
    If for some reason you need to reset, call this
    */
    open func resetAnimations() {
        if isAnimating {
            stopAnimating()
            startAnimating()
        }
    }

    /**
    Start or stop animating the indicator
    
    - parameter animate: BOOL
    */
    open func setAnimating(_ animate: Bool) {
        animate ? startAnimating() : stopAnimating()
    }

    internal func startAnimating() {
        if isAnimating {
            return
        }

        let animation: CABasicAnimation = CABasicAnimation()
        animation.keyPath = "transform.rotation"
        animation.duration = 4.0
        animation.fromValue = 0.0
        animation.toValue = 2 * M_PI
        animation.repeatCount = Float.infinity
        animation.timingFunction = _timingFunction
        progressLayer.add(animation, forKey: kNBCircleRotationAnimationKey)

        let headAnimation: CABasicAnimation = CABasicAnimation()
        headAnimation.keyPath = "strokeStart"
        headAnimation.duration = 1.0
        headAnimation.fromValue = 0.0
        headAnimation.toValue = 0.25
        headAnimation.timingFunction = _timingFunction

        let tailAnimation: CABasicAnimation = CABasicAnimation()
        tailAnimation.keyPath = "strokeEnd"
        tailAnimation.duration = 1.0
        tailAnimation.fromValue = 0.0
        tailAnimation.toValue = 1.0
        tailAnimation.timingFunction = _timingFunction

        let endHeadAnimation: CABasicAnimation = CABasicAnimation()
        endHeadAnimation.keyPath = "strokeStart"
        endHeadAnimation.beginTime = 1.0
        endHeadAnimation.duration = 0.5
        endHeadAnimation.fromValue = 0.25
        endHeadAnimation.toValue = 1.0
        endHeadAnimation.timingFunction = _timingFunction

        let endTailAnimation: CABasicAnimation = CABasicAnimation()
        endTailAnimation.keyPath = "strokeEnd"
        endTailAnimation.beginTime = 1.0
        endTailAnimation.duration = 0.5
        endTailAnimation.fromValue = 1.0
        endTailAnimation.toValue = 1.0
        endTailAnimation.timingFunction = _timingFunction

        let animations: CAAnimationGroup = CAAnimationGroup()
        animations.duration = 1.5
        animations.animations = [headAnimation, tailAnimation, endHeadAnimation, endTailAnimation]
        animations.repeatCount = Float.infinity
        progressLayer.add(animations, forKey: kNBCircleStrokeAnimationKey)

        _isAnimating = true

        if hidesWhenStopped {
            isHidden = false
        }
    }

    internal func stopAnimating() {
        if !isAnimating {
            return
        }

        progressLayer.removeAnimation(forKey: kNBCircleRotationAnimationKey)
        progressLayer.removeAnimation(forKey: kNBCircleStrokeAnimationKey)
        _isAnimating = false

        if hidesWhenStopped {
            isHidden = true
        }
    }

    // MARK: - Private methods
    fileprivate func updatePath() {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width / 2, bounds.height / 2) - progressLayer.lineWidth / 2
        let startAngle:CGFloat = 0.0
        let endAngle:CGFloat = CGFloat(2.0*M_PI)
        let path: UIBezierPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)

        progressLayer.path = path.cgPath
        progressLayer.strokeStart = 0.0
        progressLayer.strokeEnd = 0.0
    }
}
