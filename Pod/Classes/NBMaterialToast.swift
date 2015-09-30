//
//  NBMaterialToast.swift
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


public enum NBLunchDuration : NSTimeInterval {
    case SHORT = 1.0
    case MEDIUM = 2.0
    case LONG = 3.5
}

@objc public class NBMaterialToast : UIView {
    private let kHorizontalMargin: CGFloat = 16.0
    private let kVerticalBottomMargin: CGFloat = 16.0

    internal let kMinHeight: CGFloat = 48.0
    internal let kHorizontalPadding: CGFloat = 24.0
    internal let kVerticalPadding: CGFloat = 16.0
    internal let kFontRoboto: UIFont = UIFont.robotoRegularOfSize(14)
    internal let kFontColor: UIColor = NBConfig.PrimaryTextLight
    internal let kDefaultBackground: UIColor = UIColor(hex: 0x323232, alpha: 1.0)

    internal var lunchDuration: NBLunchDuration!
    internal var hasRoundedCorners: Bool!
    internal var constraintViews: [String: AnyObject]!
    internal var constraintMetrics: [String: AnyObject]!

    override init(frame: CGRect) {
        super.init(frame: frame)

        lunchDuration = NBLunchDuration.MEDIUM
        hasRoundedCorners = true
        userInteractionEnabled = false
        backgroundColor = kDefaultBackground
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    internal func __show() {
        UIView.animateWithDuration(0.2, animations: {
            self.alpha = 1.0
            }, completion: { (finished) in
                self.__hide()
        })
    }

    internal func __hide() {
        UIView.animateWithDuration(0.8, delay: lunchDuration.rawValue, options: [], animations: {
            self.alpha = 0.0
            }, completion: { (finished) in
                self.removeFromSuperview()
        })
    }

    internal class func __createWithTextAndConstraints(windowView: UIView, text: String, duration: NBLunchDuration) -> NBMaterialToast {

        let toast = NBMaterialToast()
        toast.lunchDuration = duration
        toast.alpha = 0.0
        toast.translatesAutoresizingMaskIntoConstraints = false

        let textLabel = UILabel()

        textLabel.backgroundColor = UIColor.clearColor()
        textLabel.textAlignment = NSTextAlignment.Left
        textLabel.font = toast.kFontRoboto
        textLabel.textColor = toast.kFontColor
        textLabel.numberOfLines = 0
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.text = text

        if toast.hasRoundedCorners! {
            toast.layer.masksToBounds = true
            toast.layer.cornerRadius = 15.0
        }

        toast.addSubview(textLabel)

        windowView.addSubview(toast)

        toast.constraintViews = [
            "textLabel": textLabel,
            "toast": toast
        ]
        toast.constraintMetrics = [
            "vPad": toast.kVerticalPadding,
            "hPad": toast.kHorizontalPadding,
            "minHeight": toast.kMinHeight,
            "vMargin": toast.kVerticalBottomMargin,
            "hMargin": toast.kHorizontalMargin
        ]

        toast.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-vPad-[textLabel]-vPad-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: toast.constraintMetrics, views: toast.constraintViews))
        toast.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-hPad-[textLabel]-hPad-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: toast.constraintMetrics, views: toast.constraintViews))

        toast.setContentHuggingPriority(750, forAxis: UILayoutConstraintAxis.Vertical)
        toast.setContentHuggingPriority(750, forAxis: UILayoutConstraintAxis.Horizontal)
        toast.setContentCompressionResistancePriority(750, forAxis: UILayoutConstraintAxis.Horizontal)

        windowView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[toast(>=minHeight)]-vMargin-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: toast.constraintMetrics, views: toast.constraintViews))
        windowView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(>=hMargin)-[toast]-(>=hMargin)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: toast.constraintMetrics, views: toast.constraintViews))
        windowView.addConstraint(NSLayoutConstraint(item: toast, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: windowView, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))

        return toast

    }

    /**
    Displays a classic toast message with a user defined text, shown for a standard period of time

    - parameter windowView: The window which the toast is to be attached
    - parameter text: The message to be displayed
    */
    public class func showWithText(windowView: UIView, text: String) {
        NBMaterialToast.showWithText(windowView, text: text, duration: NBLunchDuration.MEDIUM)
    }

    /**
    Displays a classic toast message with a user defined text and duration
    
    - parameter windowView: The window which the toast is to be attached
    - parameter text: The message to be displayed
    - parameter duration: The duration of the toast
    */
    public class func showWithText(windowView: UIView, text: String, duration: NBLunchDuration) {
        let toast: NBMaterialToast = NBMaterialToast.__createWithTextAndConstraints(windowView, text: text, duration: duration)
        toast.__show()
    }
}