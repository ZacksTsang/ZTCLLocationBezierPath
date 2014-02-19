Pod::Spec.new do |spec|
  spec.name         = 'ZTCLLocationBezierPath'
  spec.version      = '0.0.1'
  spec.authors      = { 'ZacksTsang' => 'zshaojia@gmail.com' }
  spec.license      = 'LICENSE'
  spec.homepage     = 'https://github.com/ZacksTsang/ZTCLLocationBezierPath'
  spec.summary      = 'To draw bezier curves on UIMapView'
  spec.source       = { :git => 'https://github.com/ZacksTsang/ZTCLLocationBezierPath.git', :tag => spec.version.to_s }
  spec.source_files = 'ZTBezierHelper/*.{h,m}'
  spec.platform     = :ios
  spec.requires_arc     = true
  spec.frameworks   = 'MapKit'
end
