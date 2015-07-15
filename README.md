# blinkspec

`blinkspec` is a little ruby gem that was created to utilize the [blink(1)](http://blink1.thingm.com/) USB RGB LED by ThingM when executing long-running [rspec](http://www.relishapp.com/rspec) tests.

With blinkspec, you can run your specs just like always, and your blink(1) will indicate that either your tests are still running, have finished and what results (all green, number of pending and number of failing specs) you got.

## Installation

`gem install blinkspec`

## Usage

Just replace your use of `bundle exec rspec` with `blinkspec` and you’re good to go. All regular rspec arguments are supported except for format parameters.

`blinkspec spec/`
`blinkspec spec/ --tag debug`

# Contributing

Any pull request of any size is welcome! :)