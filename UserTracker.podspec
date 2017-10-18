#
# Be sure to run `pod lib lint UserTracker.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'UserTracker'
  s.version          = '0.1.0'
  s.summary          = 'A demo for user track function.'

  s.description      = <<-DESC
    将统计打点和业务分离，降低耦合，方便管理统计点。进入页面后，使用Aspects Hook需要打点的方法；离开页面后，解除Hook。
                       DESC

  s.homepage         = 'https://github.com/slkai/UserTracker'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'alan' => 'alandeng@meijiabang.cn' }
  s.source           = { :git => 'https://github.com/slkai/UserTracker.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'UserTracker/Classes/**/*'
  
  # s.resource_bundles = {
  #   'UserTracker' => ['UserTracker/Assets/*.png']
  # }

#s.module_name = 'UserTracker'
  #s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'Aspects', '~> 1.4.1'
end
