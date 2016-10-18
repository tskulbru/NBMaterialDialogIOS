//
//  ViewController.swift
//  NBMaterialDialogIOS
//
//  Created by Torstein Skulbru on 06/10/2015.
//  Copyright (c) 06/10/2015 Torstein Skulbru. All rights reserved.
//

import UIKit
import NBMaterialDialogIOS

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

//        modalPresentationStyle = UIModalPresentationStyle.FormSheet
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        let loadingIndicatorView = NBMaterialCircularActivityIndicator(frame: CGRect(x: 247, y: 46, width: 48, height: 48))
        loadingIndicatorView.setAnimating(true)
        view.addSubview(loadingIndicatorView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /**
    Lets you run a block of code after a delay defined in seconds

    :param: delay The delay defined in seconds
    :param: closure The block of code you wish to run
    */
    private func delay(delay: Double, closure: (Void) -> Void) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }

    @IBAction func handleShowAlert(sender: AnyObject) {
        NBMaterialAlertDialog.showAlertWithText(view, text: "Simple alert dialog", okButtonTitle: "OK", action: nil, cancelButtonTitle: nil)
    }
    @IBAction func handleShowAlertWithTitle(sender: AnyObject) {
        NBMaterialAlertDialog.showAlertWithTextAndTitle(view, text: "Simple alert dialog", title: "Catchy Title", dialogHeight: 160, okButtonTitle: "AGREE", action: nil, cancelButtonTitle: "DISAGREE")
    }
    @IBAction func handleShowLoadingDialog(sender: AnyObject) {
        let loadingDialog = NBMaterialLoadingDialog.showLoadingDialogWithText(view, message: "Loading something..")
        delay(3, closure: { () in
            loadingDialog.hideDialog()
        })
    }
    @IBAction func handleShowToast(sender: AnyObject) {
        NBMaterialToast.showWithText(view, text: "Super awesome toast message, cheers!", duration: NBLunchDuration.LONG)
    }
    @IBAction func handleShowSnackbar(sender: AnyObject) {
        NBMaterialSnackbar.showWithText(view, text: "Super awesome toast message, cheers!", duration: NBLunchDuration.LONG)
    }
}
