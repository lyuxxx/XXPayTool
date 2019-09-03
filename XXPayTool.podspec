
Pod::Spec.new do |s|
  s.name             = 'XXPayTool'
  s.version          = '0.2.0'
  s.summary          = '集成主流支付方式'

  s.description      = <<-DESC
集成主流支付方式，包括Apple Pay、微信、支付宝、银联
                       DESC

  s.homepage         = 'https://github.com/lyuxxx/XXPayTool'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'lyuxxx' => 'lyxiel@163.com' }
  s.source           = { :git => 'https://github.com/lyuxxx/XXPayTool.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'XXPayTool/*.{h,m}'
  s.public_header_files = "XXPayTool/XXPayTool.h"
  s.requires_arc = true

  s.dependency "LLAPPaySDK"
  s.dependency "XXWeChatSDK"
  s.dependency "XXAlipaySDK"
  s.dependency "UnionPay"
  
end
