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

        NBMaterialToast.showWithText("kajdasd", duration: NBLunchDuration.LONG)
        var indicator = NBMaterialCircularActivityIndicator(frame: CGRect(x: 100, y: 100, width: 50, height: 50))
        view.addSubview(indicator)
        indicator.setAnimating(true)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func handleShowAlert(sender: AnyObject) {
        let alertDialog: NBMaterialDialog = NBMaterialAlertDialog.showAlertWithText("test", okButtonTitle: "OK", action: nil, cancelButtonTitle: nil)
        alertDialog.modalPresentationStyle = UIModalPresentationStyle.FormSheet

        self.presentViewController(alertDialog, animated: true, completion: nil)
    }
}

