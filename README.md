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

You include `Debug` in the classes you want to run the 
`debug` method in

The DEBUG environment variables controls debug logging
for classes with space or comma seperated Module/Class namespaces

    DEBUG='MySuperClass"

Would enable debug in the `MySuperClass` alone

    DEBUG='Class::Sub::*,Other::*'

Would turn debug on for any Objects including `Debug` scoped under `Class::Sub::` and `Other::`

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
