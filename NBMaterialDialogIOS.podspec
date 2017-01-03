#
# Be sure to run `pod lib lint NBMaterialDialogIOS.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "NBMaterialDialogIOS"
  s.version          = "0.2.3"
  s.summary          = "NBMaterialDialogIOS contains different dialogs and components used in Material Design by Google, on iOS."
  s.homepage         = "https://github.com/tskulbru/NBMaterialDialogIOS"
  #s.screenshots     = "https://github.com/tskulbru/NBMaterialDialogIOS/blob/master/Screenshots/appdemo.gif"
  s.license          = 'MIT'
  s.author           = { "Torstein Skulbru" => "serrghi@gmail.com" }
  s.source           = { :git => "https://github.com/tskulbru/NBMaterialDialogIOS.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/tskulbru'

  s.platform     = :ios, '8.1'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*.swift'
  s.resource = 'Pod/Assets/*.ttf'
#  s.resource_bundles = {
#   'NBMaterialDialogIOS' => ['Pod/Assets/*.ttf']
# }


  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'BFPaperButton', '~> 2.1.1'
end
