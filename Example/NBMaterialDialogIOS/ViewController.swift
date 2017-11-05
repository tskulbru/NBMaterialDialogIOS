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

    override func viewWillAppear(_ animated: Bool) {
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
    fileprivate func delay(_ delay: Double, closure: @escaping (Void) -> Void) {
//        DispatchQueue.main.asyncAfter(
//            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }

    @IBAction func handleShowAlert(_ sender: AnyObject) {
        NBMaterialAlertDialog.showAlertWithText(view, text: "Simple alert dialog", okButtonTitle: "OK", action: nil, cancelButtonTitle: nil)
    }
    @IBAction func handleShowAlertWithTitle(_ sender: AnyObject) {
        NBMaterialAlertDialog.showAlertWithTextAndTitle(view, text: "Simple alert dialog", title: "Catchy Title", dialogHeight: 160, okButtonTitle: "AGREE", action: nil, cancelButtonTitle: "DISAGREE")
    }
    @IBAction func handleShowLoadingDialog(_ sender: AnyObject) {
        let loadingDialog = NBMaterialLoadingDialog.showLoadingDialogWithText(view, message: "Loading something..")
        delay(3, closure: { () in
            loadingDialog.hideDialog()
        })
    }
    @IBAction func handleShowToast(_ sender: AnyObject) {
        NBMaterialToast.showWithText(view, text: "Super awesome toast message, cheers!", duration: NBLunchDuration.long)
    }
    @IBAction func handleShowSnackbar(_ sender: AnyObject) {
        NBMaterialSnackbar.showWithText(view, text: "Super awesome toast message, cheers!", duration: NBLunchDuration.long)
    }
}
