# debug

tiny ruby debugging utility modelled after [nodejs debug](https://github.com/visionmedia/debug)

## Installation

    $ gem install debug

Or add this line to your application's Gemfile:

```ruby
gem 'debug'
```

And then execute:

    $ bundle

## Usage

```ruby
require "debug
```

Then you can include `Debug` into the classes you want to run the `debug` method in

```ruby
class Something
  include Debug
end
```

The DEBUG environment variables controls what debug logging occurs.

    DEBUG='MySuperClass"

Would enable debug in the `MySuperClass` alone

    DEBUG='Class::Sub::*, Other::*'

Would turn debug on for any Classes or Modules scoped under `Class::Sub::` and `Other::`

```ruby
class Something
  include Debug

  def some_method
    a = "3208f23-23".split 2
    debug 'split', a
  end
end

Something.new.some_method
```

    $ DEBUG='Something' ruby something.rb


## Contributing

1. Fork it ( https://github.com/deployable/debug/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
