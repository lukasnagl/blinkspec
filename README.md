# blinkspec

[![Build Status](https://travis-ci.org/j4zz/blinkspec.svg)](https://travis-ci.org/j4zz/blinkspec) [![Gem Version](https://badge.fury.io/rb/blinkspec.svg)](http://badge.fury.io/rb/blinkspec)

`blinkspec` is a ruby gem that was created to utilize the [blink(1)](http://blink1.thingm.com/) USB RGB LED by ThingM when executing long-running [rspec](http://www.relishapp.com/rspec) tests.

With blinkspec, you can run your specs just like you’re used to, and your blink(1) will indicate that:

  * Your specs are still running.
  * `blinkspec` detected an error in your specs while running.
  * Your specs have finished running and are either all green, have pending specs left or have failing specs left.

## Installation

`gem install blinkspec`

## Usage

Just replace your use of `bundle exec rspec` with `blinkspec` and you’re good to go. All regular rspec arguments are supported except for format parameters.

```
blinkspec spec/
blinkspec spec/ --tag debug
```

# Contributing

Any pull request of any size is welcome! :)