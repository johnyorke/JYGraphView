Pod::Spec.new do |spec|
  spec.name         = 'JYGraphView'
  spec.version      = '0.1.0'
  spec.license      = { :type => 'MIT' }
  spec.homepage     = 'https://github.com/johnyorke/JYGraphView.git'
  spec.authors      = { 'John Yorke' => 'hello@johnyorke.me' }
  spec.summary      = 'Simple line graph view for iOS.'
  spec.source       = { :git => 'https://github.com/johnyorke/JYGraphView.git', :tag => spec.version }
  spec.source_files = 'JYGraphViewDemoProject/JYGraphViewDemoProject/{JYGraphView,JYGraphPoint}.{h,m}'
  spec.platform     = :ios, '6.0'
  spec.requires_arc = true
end
