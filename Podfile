# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'CountrySearch' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

	pod 'Moya'
	pod 'ReactiveCocoa' 	
	pod 'ObjectMapper'
	pod 'SVGKit', :git => 'https://github.com/SVGKit/SVGKit.git', :branch => '2.x'
	pod 'RealmSwift'

end

## Workaround until these libs migrate to swift 4.2.
post_install do |installer|
    installer.pods_project.targets.each do |target|
        if target.name == 'ReactiveCocoa'
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '4'
            end
        end
    end
end
