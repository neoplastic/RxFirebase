#
# Be sure to run `pod lib lint RxFirebase.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "RxFirebase"
  s.version          = "0.1.0"
  s.summary          = "Make Firebase reactive."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Make Firebase reactive.

Compatable with the new Firebase frameworks
                       DESC

  s.homepage         = "https://github.com/neoplastic/RxFirebase"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "David Wong" => "neoplastic@gmail.com" }
  s.source           = { :git => "https://github.com/neoplastic/RxFirebase.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/danvari'

  s.ios.deployment_target = '8.0'

  s.source_files = 'RxFirebase/Classes/**/*'

  s.ios.dependency 'Firebase', '~> 3.2.0'
  s.ios.dependency 'Firebase/Auth'
  s.ios.dependency 'Firebase/Database'
  s.ios.dependency 'Firebase/Messaging'
  s.ios.dependency 'Firebase/Storage'
  s.ios.dependency 'RxOptional', '~> 2.0.0'
  s.dependency 'RxSwift', '~> 2.5.0'

  s.pod_target_xcconfig = {
    'ENABLE_BITCODE'         => 'NO',
    'FRAMEWORK_SEARCH_PATHS' => '$(inherited) $(PODS_ROOT)/**',
    'OTHER_LDFLAGS'          => '$(inherited) -undefined dynamic_lookup'
  }
end
