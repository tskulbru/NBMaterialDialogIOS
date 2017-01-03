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
    let identifier = bundle.bundleIdentifier
    let fileExtension = "ttf"

    let url: NSURL?
    if identifier?.hasPrefix("org.cocoapods") == true {
      url = bundle.URLForResource(name, withExtension: fileExtension, subdirectory: "NBMaterialDialogIOS.bundle")
    } else {
      url = bundle.URLForResource(name, withExtension: fileExtension)
    }

    guard let fontURL = url else { fatalError("\(name) not found in bundle") }

    guard let data = NSData(contentsOfURL: fontURL),
      let provider = CGDataProviderCreateWithCFData(data) else { return }
    let font = CGFontCreateWithDataProvider(provider)

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
