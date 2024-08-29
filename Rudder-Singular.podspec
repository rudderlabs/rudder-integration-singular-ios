Pod::Spec.new do |s|
    s.name             = 'Rudder-Singular'
    s.version          = '1.1.0'
    s.summary          = 'Privacy and Security focused Segment-alternative. Singular App Events Native SDK integration support.'

    s.description      = <<-DESC
    Rudder is a platform for collecting, storing and routing customer event data to dozens of tools. Rudder is open-source, can run in your cloud environment (AWS, GCP, Azure or even your data-centre) and provides a powerful transformation framework to process your event data on the fly.
    DESC

    s.homepage         = 'https://github.com/rudderlabs/rudder-integration-singular-ios'
    s.license          = { :type => "Apache", :file => "LICENSE.md" }
    s.author           = { 'Rudderlabs' => 'arnab@rudderlabs.com' }
    s.source           = { :git => 'https://github.com/rudderlabs/rudder-integration-singular-ios.git', :tag => "v#{s.version}" }
    s.platform         = :ios, "13.0"

    s.pod_target_xcconfig = {
      'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'
    }
    s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }

    s.source_files = 'Rudder-Singular/Classes/**/*'
    
    s.static_framework = true

    s.dependency 'Rudder', '~> 1.0'
    s.dependency 'Singular-SDK', '12.5.0'
end
