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
    let identifier = bundle.bundleIdentifier
    let fileExtension = "ttf"

    let url: URL?
    if identifier?.hasPrefix("org.cocoapods") == true {
      url = bundle.url(forResource: name, withExtension: fileExtension, subdirectory: "NBMaterialDialogIOS.bundle")
    } else {
      url = bundle.url(forResource: name, withExtension: fileExtension)
    }

    guard let fontURL = url else { fatalError("\(name) not found in bundle") }

    guard let data = try? Data(contentsOf: fontURL),
      let provider = CGDataProvider(data: data as CFData) else { return }
    let font = CGFont(provider)

    var error: Unmanaged<CFError>?
    if !CTFontManagerRegisterGraphicsFont(font!, &error) {
      let errorDescription: CFString = CFErrorCopyDescription(error!.takeUnretainedValue())
      let nsError = error!.takeUnretainedValue() as AnyObject as! NSError
      NSException(name: NSExceptionName.internalInconsistencyException, reason: errorDescription as String, userInfo: [NSUnderlyingErrorKey: nsError]).raise()
    }
  }
}


public extension UIFont {
  public class func robotoMediumOfSize(_ fontSize: CGFloat) -> UIFont {

    let family = "Roboto"
    let name = "\(family)-Medium"
    let fNames = UIFont.fontNames(forFamilyName: family)
    if fNames.isEmpty || !fNames.contains(name) {
        FontLoader.loadFont(name)
    }

    return UIFont(name: name, size: fontSize)!
  }

  public class func robotoRegularOfSize(_ fontSize: CGFloat) -> UIFont {

    let family = "Roboto"
    let name = "\(family)-Regular"
    let fNames = UIFont.fontNames(forFamilyName: family)
    if fNames.isEmpty || !fNames.contains(name) {
      FontLoader.loadFont(name)
    }

    return UIFont(name: name, size: fontSize)!
  }
}
