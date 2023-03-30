
Pod::Spec.new do |s|
  s.name             = 'WXQCategory'
  s.version          = '0.1.2'
  s.summary          = '一些常用扩展类'
  s.homepage         = 'https://github.com/xiaoqiCloud/WXQCategory'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'xiaoqiCloud' => 'xiaoqi9302@163.com' }
  s.source           = { :git => 'https://github.com/xiaoqiCloud/WXQCategory.git', :tag => s.version.to_s }
  s.ios.deployment_target = '10.0'
  s.source_files = 'WXQCategory/Classes/**/*'
  #s.resource       = 'WXQCategory/MBProgressHUD.bundle'
  s.dependency "Masonry"
  s.dependency "MBProgressHUD"
   s.resource_bundles = {
     'WXQCategory' => ['WXQCategory/Assets/*.{png,bundle}']
   }
  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
