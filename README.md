inGenerator Helpers cookbook
============================
[![Build Status](https://travis-ci.org/ingenerator/chef-ingenerator-helpers.png?branch=1.x)](https://travis-ci.org/ingenerator/chef-ingenerator-helpers)

The `ingenerator-helpers` cookbook provides simple helpers and reusable code blocks for
our various chef cookbooks.

It does not (and will not) provide recipes, LWRPs, or anything else that actually provisions
anything - and it will never depend on other cookbooks. It's literally just here to simplify
reused stuff.

Requirements
------------
- Chef 12.18 or higher
- **Ruby 2.3 or higher**

Attribute Helpers
-----------------
These are available in all recipes:

* raise_if_legacy_attributes - given a list of dot-separated attribute paths, will throw if any are
  defined. Add to recipes when updating cookbooks and dropping support for old attributes.
* raise_unless_customised - given a dot-separated attribute path, will throw if the default value
  has not been overridden.


Node environment
----------------
There are various places where configuration of an instance or a particular service depends on the
environment - broadly defined as a local development box (eg Vagrant), a remote build slave, or a
production server.

Although chef supports a fully-featured `environment` layer as well as `roles`, these are quite
heavyweight and involve repeating attribute overrides across projects in a way that has proved
tricky to maintain.

By convention, we now use a single flag in the `node[ingenerator][node_environment]` attribute, which
defaults to `:production` but should be overridden in the appropriate project-level role definition
/ Vagrantfile.

This flag can then be used at attribute / recipe level to control the default behaviour of a cookbook,
so that the environment-specific variations are visible inline with the rest of the cookbook setup
for easier tracing and debugging.

Usually, you should not toggle behaviour directly on this flag, but use it to initialise well-named
behaviour-specific attributes to a suitable value. This then allows further overriding of that logic
at the project / role level.

Methods:

* is_environment?
* not_environment?
* node_environment

For example:

```ruby
# attributes/default.rb
if is_environment?(:localdev)
  default['service']['do_thing'] = false
else
  default['service']['do_thing'] = true
end

# recipes/thing.rb
if node['service']['do_thing']
  thing_service do
    action :install
  end
end
```


Custom resources
----------------

## notification_trigger

Sometimes you just want to queue a delayed notification to cause some action to
happen right at the end of the chef run every time. There's probably an official
way to do that, but since I can't find one you can do this:

```
notification_trigger "Make a thing happen" do
  notifies :restart, 'service[brain]', :delayed
end
```

Installation
------------
Add to your `Berksfile` and using [Berkshelf](http://berkshelf.com/):

```ruby
source 'https://chef-supermarket.ingenerator.com'
cookbook 'ingenerator-helpers', '~>1.0'
```

Other cookbooks should then *depend* on ingenerator-helpers` in their `metadata.rb`

```ruby
# metadata.rb
depends 'ingenerator-helpers'
```


### Testing
See the [.travis.yml](.travis.yml) file for the current test scripts.

Contributing
------------
1. Fork the project
2. Create a feature branch corresponding to your change
3. Create specs for your change
4. Create your changes
4. Create a Pull Request on github

License & Authors
-----------------
- Author:: Andrew Coulton (andrew@ingenerator.com)

```text
Copyright 2016, inGenerator Ltd

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
