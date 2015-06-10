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


@objc public class NBMaterialAlertDialog : NBMaterialDialog {

    /**
    Displays an alert dialog with a simple text and buttons
    
    :param: text The main alert message
    :param: okButtonTitle The positive button if multiple buttons, or a dismiss action button if one button. Usually either OK or CANCEL (of only one button)
    :param: action The block you want to run when the user clicks any of the buttons. If no block is given, the standard dismiss action will be used
    :param: cancelButtonTitle The negative button when multiple buttons.
    */
    public class func showAlertWithText(text: String, okButtonTitle: String?, action: ((isOtherButton: Bool) -> Void)?, cancelButtonTitle: String?) {
        NBMaterialAlertDialog.showAlertWithTextAndTitle(text, title: nil, dialogHeight: nil, okButtonTitle: okButtonTitle, action: action, cancelButtonTitle: cancelButtonTitle)
    }

    /**
    Displays an alert dialog with a simple text, title and buttons.
    Remember to read Material guidelines on when to include a dialog title.

    :param: text The main alert message
    :param: title The title of the alert
    :param: okButtonTitle The positive button if multiple buttons, or a dismiss action button if one button. Usually either OK or CANCEL (of only one button)
    :param: action The block you want to run when the user clicks any of the buttons. If no block is given, the standard dismiss action will be used
    :param: cancelButtonTitle The negative button when multiple buttons.
    */
    public class func showAlertWithTextAndTitle(text: String, title: String?, dialogHeight: CGFloat?, okButtonTitle: String?, action: ((isOtherButton: Bool) -> Void)?, cancelButtonTitle: String?) {
        let alertLabel = UILabel()
        alertLabel.numberOfLines = 0
        alertLabel.font = UIFont(name: "Roboto-Regular", size: 14)
        alertLabel.textColor = NBConfig.PrimaryTextDark
        alertLabel.text = text
        alertLabel.sizeToFit()

        let dialog = NBMaterialDialog()
        dialog.showDialog(title, content: alertLabel, dialogHeight: dialogHeight ?? dialog.kMinimumHeight, okButtonTitle: okButtonTitle, action: action, cancelButtonTitle: cancelButtonTitle)
    }
}