//
//  NBMaterialDialog.swift
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


import BFPaperButton

/**
Simple material dialog class
*/
@objc open class NBMaterialDialog : UIViewController {
    // MARK: - Class variables
    fileprivate var overlay: UIView?
    fileprivate var titleLabel: UILabel?
    fileprivate var containerView: UIView = UIView()
    fileprivate var contentView: UIView = UIView()
    fileprivate var okButton: BFPaperButton?
    fileprivate var cancelButton: BFPaperButton?
    fileprivate var tapGesture: UITapGestureRecognizer!
    fileprivate var backgroundColor: UIColor!
    fileprivate var windowView: UIView!
    fileprivate var tappableView: UIView = UIView()

    fileprivate var isStacked: Bool = false

    fileprivate let kBackgroundTransparency: CGFloat = 0.7
    fileprivate let kPadding: CGFloat = 16.0
    fileprivate let kWidthMargin: CGFloat = 40.0
    fileprivate let kHeightMargin: CGFloat = 24.0
    internal var kMinimumHeight: CGFloat {
        return 120.0
    }

    fileprivate var _kMaxHeight: CGFloat?
    internal var kMaxHeight: CGFloat {
        if _kMaxHeight == nil {
            let window = UIScreen.main.bounds
            _kMaxHeight = window.height - kHeightMargin - kHeightMargin
        }
        return _kMaxHeight!
    }

    internal var strongSelf: NBMaterialDialog?
    internal var userAction: ((_ isOtherButton: Bool) -> Void)?
    internal var constraintViews: [String: AnyObject]!

    // MARK: - Constructors
    public convenience init() {
        self.init(color: UIColor.white)
    }
    
    public convenience init(color: UIColor) {
        self.init(nibName: nil, bundle:nil)
        view.frame = UIScreen.main.bounds
        view.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleWidth]
        view.backgroundColor = UIColor(red:0, green:0, blue:0, alpha:kBackgroundTransparency)
        tappableView.backgroundColor = UIColor.clear
        tappableView.frame = view.frame
        view.addSubview(tappableView)
        backgroundColor = color
        setupContainerView()
        view.addSubview(containerView)
        
        //Retaining itself strongly so can exist without strong refrence
        strongSelf = self
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName:nibNameOrNil, bundle:nibBundleOrNil)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Dialog Lifecycle

    /**
        Hides the dialog
    */
    open func hideDialog() {
        hideDialog(-1)
    }

    /**
    Hides the dialog, sending a callback if provided when dialog was shown
    :params: buttonIndex The tag index of the button which was clicked
    */
    internal func hideDialog(_ buttonIndex: Int) {

        if buttonIndex >= 0 {
            if let userAction = userAction {
                userAction(buttonIndex > 0)
            }
        }

        tappableView.removeGestureRecognizer(tapGesture)

        for childView in view.subviews {
            childView.removeFromSuperview()
        }

        view.removeFromSuperview()
        strongSelf = nil
    }

    /**
    Displays a simple dialog using a title and a view with the content you need

    - parameter windowView: The window which the dialog is to be attached
    - parameter title: The dialog title
    - parameter content: A custom content view
    */
    open func showDialog(_ windowView: UIView, title: String?, content: UIView) -> Self {
        return showDialog(windowView, title: title, content: content, dialogHeight: nil, okButtonTitle: nil, action: nil, cancelButtonTitle: nil, stackedButtons: false)
    }

    /**
    Displays a simple dialog using a title and a view with the content you need

    - parameter windowView: The window which the dialog is to be attached
    - parameter title: The dialog title
    - parameter content: A custom content view
    - parameter dialogHeight: The height of the dialog
    */
    open func showDialog(_ windowView: UIView, title: String?, content: UIView, dialogHeight: CGFloat?) -> Self {
        return showDialog(windowView, title: title, content: content, dialogHeight: dialogHeight, okButtonTitle: nil, action: nil, cancelButtonTitle: nil, stackedButtons: false)
    }

    /**
    Displays a simple dialog using a title and a view with the content you need

    - parameter windowView: The window which the dialog is to be attached
    - parameter title: The dialog title
    - parameter content: A custom content view
    - parameter dialogHeight: The height of the dialog
    - parameter okButtonTitle: The title of the last button (far-most right), normally OK, CLOSE or YES (positive response).
    */
    open func showDialog(_ windowView: UIView, title: String?, content: UIView, dialogHeight: CGFloat?, okButtonTitle: String?) -> Self {
        return showDialog(windowView, title: title, content: content, dialogHeight: dialogHeight, okButtonTitle: okButtonTitle, action: nil, cancelButtonTitle: nil, stackedButtons: false)
    }

    /**
    Displays a simple dialog using a title and a view with the content you need

    - parameter windowView: The window which the dialog is to be attached
    - parameter title: The dialog title
    - parameter content: A custom content view
    - parameter dialogHeight: The height of the dialog
    - parameter okButtonTitle: The title of the last button (far-most right), normally OK, CLOSE or YES (positive response).
    - parameter action: The action you wish to invoke when a button is clicked
    */
    open func showDialog(_ windowView: UIView, title: String?, content: UIView, dialogHeight: CGFloat?, okButtonTitle: String?, action: ((_ isOtherButton: Bool) -> Void)?) -> Self {
        return showDialog(windowView, title: title, content: content, dialogHeight: dialogHeight, okButtonTitle: okButtonTitle, action: action, cancelButtonTitle: nil, stackedButtons: false)
    }

    /**
    Displays a simple dialog using a title and a view with the content you need

    - parameter windowView: The window which the dialog is to be attached
    - parameter title: The dialog title
    - parameter content: A custom content view
    - parameter dialogHeight: The height of the dialog
    - parameter okButtonTitle: The title of the last button (far-most right), normally OK, CLOSE or YES (positive response).
    - parameter action: The action you wish to invoke when a button is clicked
    */
    open func showDialog(_ windowView: UIView, title: String?, content: UIView, dialogHeight: CGFloat?, okButtonTitle: String?, action: ((_ isOtherButton: Bool) -> Void)?, cancelButtonTitle: String?) -> Self {
        return showDialog(windowView, title: title, content: content, dialogHeight: dialogHeight, okButtonTitle: okButtonTitle, action: action, cancelButtonTitle: cancelButtonTitle, stackedButtons: false)
    }

    /**
    Displays a simple dialog using a title and a view with the content you need

    - parameter windowView: The window which the dialog is to be attached
    - parameter title: The dialog title
    - parameter content: A custom content view
    - parameter dialogHeight: The height of the dialog
    - parameter okButtonTitle: The title of the last button (far-most right), normally OK, CLOSE or YES (positive response).
    - parameter action: The action you wish to invoke when a button is clicked
    - parameter cancelButtonTitle: The title of the first button (the left button), normally CANCEL or NO (negative response)
    - parameter stackedButtons: Defines if a stackd button view should be used
    */
    open func showDialog(_ windowView: UIView, title: String?, content: UIView, dialogHeight: CGFloat?, okButtonTitle: String?, action: ((_ isOtherButton: Bool) -> Void)?, cancelButtonTitle: String?, stackedButtons: Bool) -> Self {

        isStacked = stackedButtons

        var totalButtonTitleLength: CGFloat = 0.0

        self.windowView = windowView
        
        let windowSize = windowView.bounds

        windowView.addSubview(view)
        view.frame = windowView.bounds
        tappableView.frame = view.frame
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(NBMaterialDialog.tappedBg))
        tappableView.addGestureRecognizer(tapGesture)

        setupContainerView()
        // Add content to contentView
        contentView = content
        setupContentView()


        if let title = title {
            setupTitleLabelWithTitle(title)
        }

        if let okButtonTitle = okButtonTitle {
            totalButtonTitleLength += (okButtonTitle.uppercased() as NSString).size(attributes: [NSFontAttributeName: UIFont.robotoMediumOfSize(14)]).width + 8
            if let cancelButtonTitle = cancelButtonTitle {
                totalButtonTitleLength += (cancelButtonTitle.uppercased() as NSString).size(attributes: [NSFontAttributeName: UIFont.robotoMediumOfSize(14)]).width + 8
            }

            // Calculate if the combined button title lengths are longer than max allowed for this dialog, if so use stacked buttons.
            let buttonTotalMaxLength: CGFloat = (windowSize.width - (kWidthMargin*2)) - 16 - 16 - 8
            if totalButtonTitleLength > buttonTotalMaxLength {
                isStacked = true
            }
        }

        // Always display a close/ok button, but setting a title is optional.
        if let okButtonTitle = okButtonTitle {
            setupButtonWithTitle(okButtonTitle, button: &okButton, isStacked: isStacked)
            if let okButton = okButton {
                okButton.tag = 0
                okButton.addTarget(self, action: #selector(NBMaterialDialog.pressedAnyButton(_:)), for: UIControlEvents.touchUpInside)
            }
        }

        if let cancelButtonTitle = cancelButtonTitle {
            setupButtonWithTitle(cancelButtonTitle, button: &cancelButton, isStacked: isStacked)
            if let cancelButton = cancelButton {
                cancelButton.tag = 1
                cancelButton.addTarget(self, action: #selector(NBMaterialDialog.pressedAnyButton(_:)), for: UIControlEvents.touchUpInside)
            }
        }

        userAction = action

        setupViewConstraints()

        // To get dynamic width to work we need to comment this out and uncomment the stuff in setupViewConstraints. But its currently not working..
        containerView.frame = CGRect(x: kWidthMargin, y: (windowSize.height - (dialogHeight ?? kMinimumHeight)) / 2, width: windowSize.width - (kWidthMargin*2), height: fmin(kMaxHeight, (dialogHeight ?? kMinimumHeight)))
        containerView.clipsToBounds = true
        return self
    }

    // MARK: - View lifecycle
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        var sz = UIScreen.main.bounds.size
        let sver = UIDevice.current.systemVersion as NSString
        let ver = sver.floatValue
        if ver < 8.0 {
            // iOS versions before 7.0 did not switch the width and height on device roration
            if UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation) {
                let ssz = sz
                sz = CGSize(width:ssz.height, height:ssz.width)
            }
        }
    }

    // MARK: - User interaction
    /**
    Invoked when the user taps the background (anywhere except the dialog)
    */
    internal func tappedBg() {
        hideDialog(-1)
    }

    /**
    Invoked when a button is pressed

    - parameter sender: The button clicked
    */
    internal func pressedAnyButton(_ sender: AnyObject) {
        self.hideDialog((sender as! UIButton).tag)
    }

    // MARK: - View Constraints
    /**
    Sets up the constraints which defines the dialog
    */
    internal func setupViewConstraints() {
        if constraintViews == nil {
            constraintViews = ["content": contentView, "containerView": containerView, "window": windowView]
        }
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-24-[content]-24-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: constraintViews))
        if let titleLabel = self.titleLabel {
            constraintViews["title"] = titleLabel
            containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-24-[title]-24-[content]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: constraintViews))
            containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-24-[title]-24-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: constraintViews))
        } else {
            containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-24-[content]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: constraintViews))
        }

        if okButton != nil || cancelButton != nil {
            if isStacked {
                setupStackedButtonsConstraints()
            } else {
                setupButtonConstraints()
            }
        } else {
            containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[content]-24-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: constraintViews))
        }
        // TODO: Fix constraints for the containerView so we can remove the dialogheight var
//
//        let margins = ["kWidthMargin": kWidthMargin, "kMinimumHeight": kMinimumHeight, "kMaxHeight": kMaxHeight]
//        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(>=kWidthMargin)-[containerView(>=80@1000)]-(>=kWidthMargin)-|", options: NSLayoutFormatOptions(0), metrics: margins, views: constraintViews))
//        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(>=kWidthMargin)-[containerView(>=48@1000)]-(>=kWidthMargin)-|", options: NSLayoutFormatOptions(0), metrics: margins, views: constraintViews))
//        view.addConstraint(NSLayoutConstraint(item: containerView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
//        view.addConstraint(NSLayoutConstraint(item: containerView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0))
    }

    /**
    Sets up the constraints for normal horizontal styled button layout
    */
    internal func setupButtonConstraints() {
        if let okButton = self.okButton {
            constraintViews["okButton"] = okButton
            containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[content]-24-[okButton(==36)]-8-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: constraintViews))

            // The cancel button is only shown when the ok button is visible
            if let cancelButton = self.cancelButton {
                constraintViews["cancelButton"] = cancelButton
                containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[cancelButton(==36)]-8-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: constraintViews))
                containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[cancelButton(>=64)]-8-[okButton(>=64)]-8-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: constraintViews))
            } else {
                containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[okButton(>=64)]-8-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: constraintViews))
            }
        }
    }

    /**
    Sets up the constraints for stacked vertical styled button layout
    */
    internal func setupStackedButtonsConstraints() {
        constraintViews["okButton"] = okButton!
        constraintViews["cancelButton"] = cancelButton!

        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[content]-24-[okButton(==48)]-[cancelButton(==48)]-8-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: constraintViews))

        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[okButton]-16-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: constraintViews))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[cancelButton]-16-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: constraintViews))
    }

    // MARK: Private view helpers / initializers

    fileprivate func setupContainerView() {
        containerView.backgroundColor = backgroundColor
        containerView.layer.cornerRadius = 2.0
        containerView.layer.masksToBounds = true
        containerView.layer.borderWidth = 0.5
        containerView.layer.borderColor = UIColor(hex: 0xCCCCCC, alpha: 1.0).cgColor
        view.addSubview(containerView)
    }

    fileprivate func setupTitleLabelWithTitle(_ title: String) {
        titleLabel = UILabel()
        if let titleLabel = titleLabel {
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.font = UIFont.robotoMediumOfSize(20)
            titleLabel.textColor = UIColor(white: 0.13, alpha: 1.0)
            titleLabel.numberOfLines = 0
            titleLabel.text = title
            containerView.addSubview(titleLabel)
        }

    }

    fileprivate func setupButtonWithTitle(_ title: String, button: inout BFPaperButton?, isStacked: Bool) {
        if button == nil {
            button = BFPaperButton()
        }

        if let button = button {
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle(title.uppercased(), for: UIControlState())
            button.setTitleColor(NBConfig.AccentColor, for: UIControlState())
            button.isRaised = false
            button.titleLabel?.font = UIFont.robotoMediumOfSize(14)
            if isStacked {
                button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
                button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20)
            } else {
                button.contentEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 8)
            }

            containerView.addSubview(button)
        }
    }
    
    fileprivate func setupContentView() {
        contentView.backgroundColor = UIColor.clear
        contentView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(contentView)
    }
}
