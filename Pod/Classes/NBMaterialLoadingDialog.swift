//
//  NBMaterialLoadingDialog.swift
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

/**
    A simple loading dialog with text message
*/

@objc public class NBMaterialLoadingDialog : NBMaterialDialog {

    public var dismissOnBgTap: Bool = false

    internal override var kMinimumHeight: CGFloat {
        return 72.0
    }

    /**
        Displays a loading dialog with a loading spinner, and a message
        
        :param: message The message displayed to the user while its loading
        :returns: The Loading Dialog
    */
    public class func showLoadingDialogWithText(message: String) -> NBMaterialLoadingDialog {
        let containerView = UIView()
        let circularLoadingActivity = NBMaterialCircularActivityIndicator()
        let loadingLabel = UILabel()

        circularLoadingActivity.initialize()
        circularLoadingActivity.setTranslatesAutoresizingMaskIntoConstraints(false)
        circularLoadingActivity.lineWidth = 3.5
        circularLoadingActivity.tintColor = NBConfig.AccentColor

        containerView.addSubview(circularLoadingActivity)

        loadingLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        loadingLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        loadingLabel.font = UIFont.robotoRegularOfSize(14)
        loadingLabel.textColor = NBConfig.PrimaryTextDark
        loadingLabel.text = message
        loadingLabel.numberOfLines = 1

        containerView.addSubview(loadingLabel)

        // Setup constraints
        let constraintViews = ["spinner": circularLoadingActivity, "label": loadingLabel]
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[spinner(==32)]-16-[label]|", options: NSLayoutFormatOptions(0), metrics: nil, views: constraintViews))
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[spinner(==32)]", options: NSLayoutFormatOptions(0), metrics: nil, views: constraintViews))
        // Center Y needs to be set manually, not through VFL
        containerView.addConstraint(
            NSLayoutConstraint(
                item: circularLoadingActivity,
                attribute: NSLayoutAttribute.CenterY,
                relatedBy: NSLayoutRelation.Equal,
                toItem: containerView,
                attribute: NSLayoutAttribute.CenterY,
                multiplier: 1,
                constant: 0))
        containerView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[label]|", options: NSLayoutFormatOptions(0), metrics: nil, views: constraintViews))

        // Initialize dialog and display
        let dialog = NBMaterialLoadingDialog()
        dialog.showDialog(nil, content: containerView)

        // Start spinner
        circularLoadingActivity.startAnimating()

        return dialog
    }

    /**
    We dont want to dismiss the loading dialog when user taps bg, so we override it and do nothing
    */
    internal override func tappedBg() {
        if dismissOnBgTap {
            super.tappedBg()
        }
    }
}