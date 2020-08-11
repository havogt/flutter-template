#!/usr/bin/env ruby
require 'xcodeproj'

# IMPORTANT
# After this script I manually moved the reference from the main group to the one commented as "Runner"

proj = Xcodeproj::Project.open("Runner.xcodeproj")

# puts proj.product_ref_group
# main_prod = proj.products.first #each{|prod| puts prod.path }
# puts proj.products_group.name
ref = proj.new_file("Runner/GoogleService-Info.plist")
proj.targets.each do |target|
    puts target.name
    target.add_resources([ref])
end



# proj.objects.each{|prod| puts prod.project}

# proj.build_configurations.each {|bc| bc.settings['INFOPLIST_FILE'] = 'FOO' }
#proj.build_configurations.each do |config|
#    config.build_settings.store("CODE_SIGN_ENTITLEMENTS", "Runner/Runner.entitlements")
#end

proj.recreate_user_schemes
proj.save
