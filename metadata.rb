name 'ingenerator-helpers'
maintainer 'Andrew Coulton'
maintainer_email 'andrew@ingenerator.com'
license 'Apache-2.0'
chef_version '>=12.18.31'
description 'Simple standalone helpers for inGenerator cookbooks'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '1.1.0'
issues_url 'https://github.com/ingenerator/chef-ingenerator-helpers/issues'
source_url 'https://github.com/ingenerator/chef-ingenerator-helpers'

%w(ubuntu).each do |os|
  supports os
end

# This cookbook is NOT ALLOWED to have any dependencies....
