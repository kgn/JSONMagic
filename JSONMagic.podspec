Pod::Spec.new do |spec|
  spec.name = 'JSONMagic'
  spec.version = '0.1.1'
  spec.authors = {'David Keegan' => 'me@davidkeegan.com'}
  spec.homepage = 'https://github.com/kgn/JSONMagic'
  spec.summary = 'JSONMagic makes it easy to traverse and parse json in Swift.'  
  spec.source = {:git => 'https://github.com/kgn/JSONMagic.git', :tag => "v#{spec.version}"}
  spec.license = { :type => 'MIT', :file => 'LICENSE' }

  spec.platform = :ios, '8.0'
  spec.requires_arc = true
  spec.source_files = 'Source/JSONMagic.swift'
end
