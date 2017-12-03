Pod::Spec.new do |s|
s.name         = 'yimediter'
s.version      = '0.0.1'
s.summary      = 'A Rich Text Editor'
s.homepage     = 'https://github.com/yiiim/yimediter'
s.license      = 'MIT'
s.authors      = {'ybz' => 'ybz975218925@live.com'}
s.platform     = :ios, '8.0'
s.source       = {:git => 'git@github.com:yiiim/yimediter.git', :tag => s.version}
s.source_files = 'yimediter/**/*.{h,m}','yimediter/*.{h,m}'
s.resource     = 'yimediter/resource/*.boundle'
s.requires_arc = true
end