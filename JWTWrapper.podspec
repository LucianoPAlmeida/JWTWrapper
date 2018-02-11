#
# Be sure to run `pod lib lint JWTWrapper.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JWTWrapper'
  s.version          = '1.0.2'
  s.summary          = 'A Convenience class to wrapper the JWT token string'
  s.description = <<-DESC
                Convenience class for wrapper JWT to easilly get info and payload data. This is NOT an issuer or validator library is just a simple wrapper to parse the token in a structure. 
                        DESC
  s.homepage         = 'https://github.com/LucianoPAlmeida/JWTWrapper'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'LucianoAlmeida' => 'passos.luciano@outlook.com' }
  s.source           = { :git => 'https://github.com/LucianoPAlmeida/JWTWrapper.git', :tag => s.version }

  s.ios.deployment_target = '10.0'

  s.source_files = 'JWTWrapper/**/*.{swift,h}'
  s.public_header_files = 'JWTWrapper/JWTWrapper.h'
end

