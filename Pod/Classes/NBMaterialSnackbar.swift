//
//  NBMaterialSnackbar.swift
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

@objc open class NBMaterialSnackbar : UIView {
    // MARK: - Class variables and constants

    internal let kMinHeight: CGFloat = 48.0
    internal let kMaxHeight: CGFloat = 80.0
    internal let kHorizontalPadding: CGFloat = 24.0
    internal let kVerticalSinglePadding: CGFloat = 14.0
    internal let kVerticalMultiPadding: CGFloat = 24.0
    internal let kFontRoboto: UIFont = UIFont.robotoRegularOfSize(14)
    internal let kFontColor: UIColor = NBConfig.PrimaryTextLight
    internal let kDefaultBackground: UIColor = UIColor(hex: 0x323232, alpha: 1.0)

    internal var lunchDuration: NBLunchDuration!
    internal var hasRoundedCorners: Bool!
    internal var constraintViews: [String: AnyObject]!
    internal var constraintMetrics: [String: AnyObject]!

    internal var verticalConstraint: NSLayoutConstraint!

    internal var currentHeight: CGFloat!
    internal var textLabel: UILabel!

    // MARK: - Constructors
    override init(frame: CGRect) {
        super.init(frame: frame)

        lunchDuration = NBLunchDuration.medium
        hasRoundedCorners = false
        isUserInteractionEnabled = false
        backgroundColor = kDefaultBackground
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Internal helper methods
    internal func __show() {
        superview?.layoutIfNeeded()
        verticalConstraint.constant = 0

        UIView.animateKeyframes(withDuration: 0.4, delay: 0.2, options: [], animations: {
            self.textLabel.alpha = 1.0
        }, completion: nil)

        UIView.animate(withDuration: 0.4, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.superview?.layoutIfNeeded()
            }, completion: { (completed) in
                self.__hide()
        })
    }

    internal func __hide() {
        verticalConstraint.constant = currentHeight
        UIView.animate(withDuration: 0.4, delay: lunchDuration.rawValue, options: [], animations: {
            self.superview?.layoutIfNeeded()
            }, completion: { (finished) in
                self.removeFromSuperview()
        })
    }

    internal class func __createSingleWithTextAndDuration(_ windowView: UIView, text: String, duration: NBLunchDuration) -> NBMaterialSnackbar {

        let snack = NBMaterialSnackbar()
        snack.lunchDuration = duration
        snack.translatesAutoresizingMaskIntoConstraints = false
        snack.currentHeight = snack.kMinHeight

        snack.textLabel = UILabel()


        snack.textLabel.backgroundColor = UIColor.clear
        snack.textLabel.textAlignment = NSTextAlignment.left
        snack.textLabel.font = snack.kFontRoboto
        snack.textLabel.textColor = snack.kFontColor
        snack.textLabel.numberOfLines = 1
        snack.textLabel.alpha = 0.0
        snack.textLabel.translatesAutoresizingMaskIntoConstraints = false
        snack.textLabel.text = text

        snack.addSubview(snack.textLabel)

        windowView.addSubview(snack)

        snack.constraintViews = [
            "textLabel": snack.textLabel,
            "snack": snack
        ]
        snack.constraintMetrics = [
            "vPad": snack.kVerticalSinglePadding as AnyObject,
            "hPad": snack.kHorizontalPadding as AnyObject,
            "minHeight": snack.kMinHeight as AnyObject,
        ]

        snack.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-vPad-[textLabel]-vPad-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: snack.constraintMetrics, views: snack.constraintViews))
        snack.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-hPad-[textLabel]-hPad-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: snack.constraintMetrics, views: snack.constraintViews))

        windowView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[snack(==minHeight)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: snack.constraintMetrics, views: snack.constraintViews))
        windowView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[snack]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: snack.constraintMetrics, views: snack.constraintViews))

        snack.verticalConstraint = NSLayoutConstraint(item: snack, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: windowView, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: snack.currentHeight)
        windowView.addConstraint(snack.verticalConstraint)
        
        
        return snack
    }

    // MARK: - Class functions
    // TODO: Include user actions
    // TODO: Include swipe to dismiss

    /**
    Displays a snackbar (new in material design) at the bottom of the screen
    
    - parameter text: The message to be displayed
    */
    open class func showWithText(_ windowView: UIView, text: String) {
        NBMaterialSnackbar.showWithText(windowView, text: text, duration: NBLunchDuration.medium)
    }

    /**
    Displays a snackbar (new in material design) at the bottom of the screen

    - parameter text: The message to be displayed
    - parameter duration: The duration of the snackbar
    */
    open class func showWithText(_ windowView: UIView, text: String, duration: NBLunchDuration) {
        let toast: NBMaterialSnackbar = NBMaterialSnackbar.__createSingleWithTextAndDuration(windowView, text: text, duration: duration)
        toast.__show()
    }
}
