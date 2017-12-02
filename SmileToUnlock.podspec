Pod::Spec.new do |s|
  s.name             = 'SmileToUnlock'
  s.version          = '1.0.0'
  s.summary          = 'Make your users smile before opening the app :)'
 
  s.description      = <<-DESC
This library uses ARKit Face Tracking in order to catch a user's smile.
                       DESC
 
  s.homepage         = 'https://github.com/rsrbk/SmileToUnlock.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE.txt' }
  s.author           = { 'Ruslan Serebriakov' => 'rsrbk1@gmail.com' }
  s.source           = { :git => 'https://github.com/rsrbk/SmileToUnlock.git', :tag => s.version.to_s }
 
  s.ios.deployment_target = '11.0'
  s.source_files = 'SmileToUnlock/**/*.swift'
end
