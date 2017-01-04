//
//  NBMaterialAlertDialog.swift
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


@objc open class NBMaterialAlertDialog : NBMaterialDialog {

    /**
    Displays an alert dialog with a simple text and buttons

    - parameter windowView: The window which the dialog is to be attached
    - parameter text: The main alert message
    - parameter okButtonTitle: The positive button if multiple buttons, or a dismiss action button if one button. Usually either OK or CANCEL (of only one button)
    - parameter action: The block you want to run when the user clicks any of the buttons. If no block is given, the standard dismiss action will be used
    - parameter cancelButtonTitle: The negative button when multiple buttons.
    */
    @discardableResult
    open class func showAlertWithText(_ windowView: UIView, text: String, okButtonTitle: String?, action: ((_ isOtherButton: Bool) -> Void)?, cancelButtonTitle: String?) -> NBMaterialAlertDialog {
        return NBMaterialAlertDialog.showAlertWithTextAndTitle(windowView, text: text, title: nil, dialogHeight: nil, okButtonTitle: okButtonTitle, action: action, cancelButtonTitle: cancelButtonTitle)
    }

    /**
    Displays an alert dialog with a simple text, title and buttons.
    Remember to read Material guidelines on when to include a dialog title.

    - parameter windowView: The window which the dialog is to be attached
    - parameter text: The main alert message
    - parameter title: The title of the alert
    - parameter okButtonTitle: The positive button if multiple buttons, or a dismiss action button if one button. Usually either OK or CANCEL (of only one button)
    - parameter action: The block you want to run when the user clicks any of the buttons. If no block is given, the standard dismiss action will be used
    - parameter cancelButtonTitle: The negative button when multiple buttons.
    */
    @discardableResult
    open class func showAlertWithTextAndTitle(_ windowView: UIView, text: String, title: String?, dialogHeight: CGFloat?, okButtonTitle: String?, action: ((_ isOtherButton: Bool) -> Void)?, cancelButtonTitle: String?) -> NBMaterialAlertDialog {
        let alertLabel = UILabel()
        alertLabel.numberOfLines = 0
        alertLabel.font = UIFont.robotoRegularOfSize(14)
        alertLabel.textColor = NBConfig.PrimaryTextDark
        alertLabel.text = text
        alertLabel.sizeToFit()

        let dialog = NBMaterialAlertDialog()
        return dialog.showDialog(windowView, title: title, content: alertLabel, dialogHeight: dialogHeight ?? dialog.kMinimumHeight, okButtonTitle: okButtonTitle, action: action, cancelButtonTitle: cancelButtonTitle)
    }
}
