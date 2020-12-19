# Mass pay grouping exercise

Implement a module that:

+ Given a collection of payouts going to different recipients [identified by email]
+ Group payment items by a group size
+ A recipient should not receive more than one payment in each group (real world ~ no more than one payment for a day for a recipient)
+ Order payments such as recipients listed after a long string of a same recipient payouts are not penalized

# Code

## A. Installation

1. Use RVM or rbenv
2. clone this repository and `cd` into it, then `bundle install`

The dependencies are:

+ [Thor](http://whatisthor.com/) for the main command entry
+ Pry
+ Rubocop
+ Byebug

## B. Running the CLI app

Given the following sample data:

```
[
  { email: 'bob@example.com', amount: 400 },
  { email: 'susan@example.com', amount: 8000 },
  { email: 'bob@example.com', amount: 400 },
  { email: 'alan@example.com', amount: 300 },
  { email: 'alan@example.com', amount: 12 },
  { email: 'dana@example.com', amount: 675 }
]
```
Run `thor run:sample` to output the resulting grouped payouts

## C. Test

Quite simple, just run `rake` or `rake test` to launch the test

The test matrix covers 4 behaviors:

1. Empty collection should return empty result
2. A given payouts flat collection should return a grouped payouts collection
3. N payouts going to the same recipient should be splited in N groups (real world ~ only 1 payout per day)
4. Recipients listed after a long string of a same recipient payouts are not penalized

## D. Internal implementation

The app is separated in 2 layers

1. The Thor command that launches the app with sample data, in `cli.thor`.
2. Main module, implemented in `lib/mass_pay.rb`. This module is responsible of the groups generation.

**Strategies**

+ Usage of recursive call
+ Recursion optimization with an accumulator
