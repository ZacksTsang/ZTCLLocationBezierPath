Pod::Spec.new do |spec|
  spec.name         = 'ZTCLLocationBezierPath'
  spec.version      = 'v1.1.1'
  spec.authors      = { 'ZacksTsang' => 'kingxiaokang@gmail.com' }
  spec.license      = 'LICENSE'
  spec.homepage     = 'https://github.com/ZacksTsang/ZTCLLocationBezierPath'
  spec.summary      = 'To draw bezier curves on UIMapView'
  spec.source       = { :git => 'https://github.com/ZacksTsang/ZTCLLocationBezierPath.git', :tag => 'v1.1.1' }
  spec.source_files = 'ZTCLLocationBezierPath/ZTBezierHelper/*.{h,m}'
  spec.platform     = :ios
  spec.requires_arc     = true
  spec.frameworks   = 'MapKit'
end
