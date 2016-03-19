# Lipstick

[![Version](https://badge.fury.io/rb/lipstick.svg)](http://badge.fury.io/rb/lipstick)
[![Downloads](https://img.shields.io/gem/dtv/lipstick.svg?style=flat-square)](https://rubygems.org/gems/lipstick)
[![Dependency Status](https://gemnasium.com/varyonic/lipstick.svg)](https://gemnasium.com/varyonic/lipstick)

Unofficial ruby wrapper for the following Lime Light CRM APIs:

* [Membership API](http://help.limelightcrm.com/entries/317874-Membership-API-Documentation)
* [Transaction API](http://help.limelightcrm.com/entries/22934241-Transaction-API-Documentation)

Note this wrapper attempts to fix some of the inconsistencies in the underlying APIs.

Online documentation is available at [rubydoc.info](http://www.rubydoc.info/github/varyonic/lipstick/master/frames)

To run the tests you will need your own Lime Light CRM account with a valid campaign and test payment method.  Populate ~/.lipstick/fixtures.yml as follows:

```
  credentials:
    url: https://.../admin
    username: ...
    password: ...
  test_card_number: '4...........'
```
Run the tests with:

```
  bundle exec ruby -I lib:test test/test_lipstick.rb -v
```

## Contributing to lipstick
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

Copyright (c) 2014 Piers Chambers and South Beach Skin Care, LLC. See LICENSE.txt for
further details.

