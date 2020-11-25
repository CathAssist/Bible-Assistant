platform :ios, '9.0'

#source 'https://github.com/CocoaPods/Specs.git'
target 'Bible Assistant' do
    
    use_frameworks!


pod 'Ono'
pod 'SGNavigationProgress'
pod 'FFCircularProgressView'
pod 'MagicalRecord', :inhibit_warnings => true
pod 'Reachability'
pod 'MBProgressHUD'

end
#
#post_install do |installer|
#    copy_pods_resources_path = "Pods/Target Support Files/Pods-Bible Assistant/Pods-Bible Assistant-resources.sh"
#    string_to_replace = '--compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"'
#    assets_compile_with_app_icon_arguments = '--compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}" --app-icon "${ASSETCATALOG_COMPILER_APPICON_NAME}" --output-partial-info-plist "${BUILD_DIR}/assetcatalog_generated_info.plist"'
#    text = File.read(copy_pods_resources_path)
#    new_contents = text.gsub(string_to_replace, assets_compile_with_app_icon_arguments)
#    File.open(copy_pods_resources_path, "w") {|file| file.puts new_contents }
#end
