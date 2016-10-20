//
//  NBRobotoFont.swift
//  Pods
//
//  Created by Torstein Skulbru on 10.06.15.
//
//

private class FontLoader {
    class func loadFont(_ name: String) {
        let bundle = Bundle(for: FontLoader.self)
        let fontURL = bundle.url(forResource: name, withExtension: "ttf")

        let data = try! Data(contentsOf: fontURL!)

        let provider = CGDataProvider(data: data as CFData)
        let font = CGFont(provider!)

        var error: Unmanaged<CFError>?
        if !CTFontManagerRegisterGraphicsFont(font, &error) {
            let errorDescription: CFString = CFErrorCopyDescription(error!.takeUnretainedValue())
            let nsError = error!.takeUnretainedValue() as AnyObject as! NSError
            NSException(name: NSExceptionName.internalInconsistencyException, reason: errorDescription as String, userInfo: [NSUnderlyingErrorKey: nsError]).raise()
        }
    }
}


public extension UIFont {
    public class func robotoMediumOfSize(_ fontSize: CGFloat) -> UIFont {
        struct Static {
            static var onceToken : Int = 0
        }

        let name = "Roboto-Medium"
        if (UIFont.fontNames(forFamilyName: name).count == 0) {
            dispatch_once(&Static.onceToken) {
                FontLoader.loadFont(name)
            }
        }

        return UIFont(name: name, size: fontSize)!
    }

    public class func robotoRegularOfSize(_ fontSize: CGFloat) -> UIFont {
        struct Static {
            static var onceToken : Int = 0
        }

        let name = "Roboto-Regular"
        if (UIFont.fontNames(forFamilyName: name).count == 0) {
            dispatch_once(&Static.onceToken) {
                FontLoader.loadFont(name)
            }
        }

        return UIFont(name: name, size: fontSize)!
    }
}
