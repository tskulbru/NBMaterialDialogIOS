//
//  NBRobotoFont.swift
//  Pods
//
//  Created by Torstein Skulbru on 10.06.15.
//
//

private class FontLoader {
    class func loadFont(name: String) {
        let bundle = NSBundle(forClass: FontLoader.self)
        let fontURL = bundle.URLForResource(name, withExtension: "ttf")

        let data = NSData(contentsOfURL: fontURL!)!

        let provider = CGDataProviderCreateWithCFData(data)
        let font = CGFontCreateWithDataProvider(provider)!

        var error: Unmanaged<CFError>?
        if !CTFontManagerRegisterGraphicsFont(font, &error) {
            let errorDescription: CFStringRef = CFErrorCopyDescription(error!.takeUnretainedValue())
            let nsError = error!.takeUnretainedValue() as AnyObject as! NSError
            NSException(name: NSInternalInconsistencyException, reason: errorDescription as String, userInfo: [NSUnderlyingErrorKey: nsError]).raise()
        }
    }
}


public extension UIFont {
    public class func robotoMediumOfSize(fontSize: CGFloat) -> UIFont {
        struct Static {
            static var onceToken : dispatch_once_t = 0
        }

        let name = "Roboto-Medium"
        if (UIFont.fontNamesForFamilyName(name).count == 0) {
            dispatch_once(&Static.onceToken) {
                FontLoader.loadFont(name)
            }
        }

        return UIFont(name: name, size: fontSize)!
    }

    public class func robotoRegularOfSize(fontSize: CGFloat) -> UIFont {
        struct Static {
            static var onceToken : dispatch_once_t = 0
        }

        let name = "Roboto-Regular"
        if (UIFont.fontNamesForFamilyName(name).count == 0) {
            dispatch_once(&Static.onceToken) {
                FontLoader.loadFont(name)
            }
        }

        return UIFont(name: name, size: fontSize)!
    }
}
