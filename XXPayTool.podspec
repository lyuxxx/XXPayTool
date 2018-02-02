#
# Be sure to run `pod lib lint XXPayTool.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'XXPayTool'
  s.version          = '0.1.0'
  s.summary          = '集成主流支付方式'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
集成主流支付方式，包括Apple Pay、微信、支付宝、银联
                       DESC

  s.homepage         = 'https://github.com/lyuxxx/XXPayTool'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'lyuxxx' => 'lyxiel@163.com' }
  s.source           = { :git => 'https://github.com/lyuxxx/XXPayTool.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'XXPayTool/*.{h,m}'
  s.public_header_files = "XXPayTool/XXPayTool.h"
  s.requires_arc = true

  s.dependency "LLAPPaySDK"
  s.dependency "XXWeChatSDK"
  s.dependency "Alipay-SDK"
  s.dependency "UnionPay"
  
end
