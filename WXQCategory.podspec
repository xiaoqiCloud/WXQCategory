
Pod::Spec.new do |s|
  s.name            = 'WXQCategory'
  s.version         = '0.1.6'
  s.summary         = '一些常用扩展类'
  s.homepage        = 'https://github.com/xiaoqiCloud/WXQCategory'
  s.license         = { :type => 'MIT', :file => 'LICENSE' }
  s.author          = { 'xiaoqiCloud' => 'xiaoqi9302@163.com' }
  s.source          = { :git => 'https://github.com/xiaoqiCloud/WXQCategory.git', :tag => s.version.to_s }
  s.platform        = :ios, "10.0"
  s.source_files    = 'WXQCategory/Classes/**/*'
  s.requires_arc    = true
  s.dependency "Masonry"
  
end
