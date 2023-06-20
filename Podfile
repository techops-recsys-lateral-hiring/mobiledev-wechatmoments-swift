# Uncomment the next line to define a global platform for your project
 platform :ios, '13.0'

target 'WeChatMoments' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for WeChatMoments
  pod 'Alamofire', '~> 5.2'
  pod 'MBProgressHUD', '~> 0.9.1'
  pod 'SwiftyJSON', '~> 4.0'
  pod "PromiseKit", "~> 6.8"

  target 'WeChatMomentsTests' do
    inherit! :search_paths
    pod 'OHHTTPStubs/Swift'
  end

  post_install do |installer|
      installer.generated_projects.each do |project|
            project.targets.each do |target|
                target.build_configurations.each do |config|
                    config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
                 end
            end
     end
  end

end
