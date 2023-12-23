#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_lightweight_store.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_lightweight_store'
  s.version          = '0.0.1'
  s.summary          = 'A light weight key-value store (i.e. SharedPreferences & NSUserdefaults)'
  s.description      = <<-DESC
A light weight key-value store (i.e. SharedPreferences & NSUserdefaults)
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'Xlightweight-Store-iOS'
  s.platform = :ios, '9.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
