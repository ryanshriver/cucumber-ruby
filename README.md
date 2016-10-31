# building the right things with mobius

`mobius` provides continuous feedback to people on whether they are **building the right things**, not just **building things right**.

Most product development tools focus on **building things right** meaning on time, on budget and with high quality.
`mobius` is different. It uses a simple language to define the desired business and product goals, such as Increase
Customer Conversion or Improve App Responsiveness. Then `mobius` uses automation to measure and report on progress
towards these goals whenever you want.

With `mobius` teams get realtime feedback on whether their new features are delivering the expected value. Leaders get
clear visibility on whether their investments are delivering the desired return. Everyone gets feedback on whether they are
**building the right things**.

Use `mobius` with our method [Mobius](http://mobiusloop.com) and other methods like
[Objectives and Key Results (OKR's)](https://www.amazon.com/Radical-Focus-Achieving-Important-Objectives-ebook/dp/B01BFKJA0Y)
to define and measure the value of your product or service.


## how it works

Today many teams write automated feature tests using open source tools like [Cucumber](http://cucumber.io). They write these
tests in a simple, readable format using the [Gherkin](https://cucumber.io/docs/reference) language. Whenever these tests are run, teams get realtime feedback
on the quality of their product.

`mobius` builds up this concept to apply automation towards product goals and business objectives. Instead of tests that report on
product quality, `mobius` reports on progress towards desired goals.

Under the covers `mobius` is built on the popular open source testing tool [Cucumber](http://cucumber.io). It consists of three main parts:
 1. `.goal` files
 1. step definitions
 1. custom `Scale`'s


#### 1. `.goal` files
To start, leaders and teams agree on their objectives and the measurable outcomes that define success.
Frameworks like [Objectives and Key Results (OKR's)](https://www.amazon.com/Radical-Focus-Achieving-Important-Objectives-ebook/dp/B01BFKJA0Y)
and [Mobius](http://mobiusloop.com) encourage qualitative statements (problems or objectives) together with quantitative
measures of success (outcomes or key results).

Using `mobius`, leaders and teams collaboratively write these in a `.goal` text file. Here's an example:

```ruby
Objective: Reach a million paying customers by Q3 2016!

  Key Result: Increase Journal Readership
    Given a baseline of 500,000 readers on Oct 1, 2015
    And a target of 1,000,000 readers by Oct 1, 2016
    Then measure progress with "Total Readers Scale"
```
Here's another one:

```ruby
Problem: Slow app response times are causing us to lose customers

  Outcome: Improve App Responsiveness
    Given a baseline of 4.5 seconds average response time on May 1, 2016
    And a target of 1.5 seconds average response time by Jun 30, 2016
    Then measure progress with "Peak User Performance Scale"
```
The syntax is based [Gherkin](https://cucumber.io/docs/reference), the language used to write Cucumber acceptance tests.
`mobius` introduces a four new keywords to Gherkin: **Objective**, **Problem**, **Outcome** and **Key Result**.

Each `.goal` file contains **one** Objective or Problem and **one or more** Outcomes or Key Results.

When the `.goal` files are run with `mobius`, they report progress towards your targets like this:

```ruby
Objective: Top a million paying customers by Q3 2016!

  Key Result: Increase Journal Readership to 1,000,000
    Given a baseline of 500000 readers on "Oct 1, 2015"
    And a target of 1000000 readers by "Oct 1, 2016"
    When we measure progress with "Total Readers Scale"
      Success! found 820,000 readers in 1.2 seconds!
    Then measure progress with "Total Readers Scale"
      Hooray! You are on track!
      64% progress to target using 61% of the time (222 days)
      36% remaining to target in 143 days
````

Progress is reported on the screen an optionally saved to a file.

With `mobius` teams can measure progress towards their goals daily, weekly, monthly or whatever cadence makes sense.
Integrating `mobius` into your continuous delivery pipeline helps measure the impacts of each new release on your outcomes or key results.


#### 2. step definitions
Under the covers, `mobius` is built on a forked copy of [cucumber-ruby](https://github.com/cucumber/cucumber-ruby).
It uses Gherkin to parse the `.goal` files and call Cucumber [step definitions](https://github.com/cucumber/cucumber/wiki/Step-Definitions).
`mobius` ships with one step definition [mobius_steps.rb](lib/mobiusloop/mobius_steps.rb) that can be modified or extended.

Inside `mobius_steps.rb`, the lines beginning with `Given` and `And` save the baseline and target values, respectively.
The line beginning with `When` creates an `Outcome` with a custom `Scale`, sets the baselines and targets, then calls
the `measure` method to perform the measurement. The line beginning with `Then` reports the progress towards targets.

This `Given, When, Then` syntax is identical to Gherkin, easing the learning curve for teams already using Cucumber.
Teams can choose to use the built-in `mobius_steps.rb` or create their own step definitions.


#### 3. custom `Scale`'s

At creation time, each outcome (or key result) is associated with a custom `Scale` of measure.
Scale's are the code that collects your data in your environment to report progress.
`mobius` ships with a few example scales, however teams are encouraged to create custom scales to meet their needs.

To create a Scale, create a new Ruby class that extends `Scale` and then implement the `measure` method. Next, update the `.goal`
 file to reference your new `Scale` class. When `mobius` parses this line:

```we measure progress with "Total Readers Scale"```

it creates a new instance of the Ruby class `TotalReadersScale` and calls the `measure` method, which returns a new `Measure`.

Here's an example:

```Ruby
require 'mobiusloop/scale'
require 'mobiusloop/measure'

class TotalReadersScale < Scale

  def measure
    total = collect_total_readers
    Measure.new(total)
  end
end
````

In this example you would implement the method `collect_total_readers` with your custom logic.


## getting started

Adding `mobius` to your product is relatively easy, but requires some command-line chops and about 20 minutes of your time.
If the following section looks like Greek, then as nicely as possible ask a developer on your team for help. Come bearing gifts!

**Note:** Currently only Ruby on Linux and OSX are tested platforms. Windows will be added in the future.

If [Ruby](https://www.ruby-lang.org/en/), [gem](https://rubygems.org) and [bundle](http://bundler.io) are not installed, install them first.

Then install `mobius` with this command:

    $ gem install mobiusloop

Once installed, create a symbolic link for the `mobius` command. First locate your ruby executable path:

    $ gem env

Look for the value of `EXECUTABLE DIRECTORY`, something like `/usr/local/Cellar/ruby/2.2.3/bin/`.
Then create a symbolic link:

    $ ln -s /path/to/executable/directory/mobius /usr/local/bin/mobius

**TODO:** Simplify to find a way to create symbolic link as part of gem install


## adding mobius to your app

To create and run your own goals, let's start with a working example and modify it.

Change to the root directory of your app and run `mobius`:

    $ cd product_root_directory
    $ mobius

You get feedback that `mobius` is not initialized. So let's do that:

    $ mobius --init

`mobius` creates a `goals/` directory and put some files in there. Let's run it again:

    $ mobius

You got feedback that `mobius` is running for your product!

If you get an error instead, attempt to debug the issue and [let us know](https://github.com/ryanshriver/mobiusloop-ruby/issues)
so we can fix it.

Now let's customize `mobius` for your needs.


# create your first goal

Mobius ships with a working goal to get you started.

Open `goals/increase_readers.goal` in your favorite text editor,
change the *baseline* or *target value*. Save and run `mobius` again. Notice changes in the progress?

Change the *baseline* or *target dates* and run `mobius` again. See more changes? Getting the hang of it?

As you experiment you may notice the progress being displayed in green, yellow or red font color.
In addition to the quantitative progress, `mobius` reports on whether you are *on track*. All this is configurable
but more on that later.


#### step 1: create .goal file

Let's pretend you have a product outcome to **improve response time** for your product from 5 seconds to 1 second.
Start by copying our working example:

    $ cp goals/increase_readers.goal goals/improve_experience.goal


#### step 2: create objectives and outcomes

Open `improve_experience.goal` in your text editor and make some changes:

 1. Update `Objective:` to reflect our new goal. How about `Improve our digital customer experience this year`
 1. Let's only start with one `Outcome`, so delete from `Outcome: Increase Published Articles by 25%` to the end of the file
 1. Now update your `Outcome:` keeping it short and sweet. How about `Improve Response Time`

When done it should look like this:

```
Objective: Improve our digital customer experience this year

 Outcome: Improve Response Time
    Given a baseline of 500000 "readers" on "Oct 1, 2016"
    And a target of 1000000 "readers" by "Oct 1, 2017"
    Then measure progress with "Total Readers Scale"
```

Save your new goal and run `mobuis` again. Notice that `mobius` runs all the `.goal` files in the `goals/` folder by default.
We can just run our new one with this command:

    $ mobius goals/improve_experience.goal

Since we don't need the example anymore, let's remove it:

    $ rm goals/increase_readers.goal


#### step 3: define baselines and targets

Let's pretend as of October 1, 2016 your app's home page takes 5 seconds to load. That's your baseline.
Since your product owner has requested *sub-second response time*, that's your target.

Open `improve_experience.goal` in your text editor and make some changes:

1. In the row starting with `Given`, change `50000` to `5` and `readers` to `seconds`
1. In the row starting with `And`, change `1000000` to `1` and `readers` to `second`

When done it should look like this:

```
Objective: Improve our digital customer experience this year

 Outcome: Improve Response Time
    Given a baseline of 5 "seconds" on "Oct 1, 2016"
    And a target of 1 "second" by "Oct 1, 2017"
    Then measure progress with "Total Readers Scale"
```

Now save the file and run `mobius` again.

This works, but we have *820,000 seconds!* That's not right, so let's fix it.


#### step 4: define scales

Open `improve_experience.goal` in your text editor and make some changes:

1. In the row starting with `When`, change "Total Readers Scale" to "Page Response Scale"

When done it should look like this:

```
Objective: Improve our digital customer experience this year

 Outcome: Improve Response Time
    Given a baseline of 5 "seconds" on "Oct 1, 2016"
    And a target of 1 "second" by "Oct 1, 2017"
    Then measure progress with "Page Response Scale"
```

Now save the file and run `mobius` again.

Wow, much better! The *Page Response Scale* generated a request to [google.com](http://google.com) and compared the
response time to your target of 1 second. It reported what percentage progress you had made to your
target in your scheduled time. The color text indicates whether you are on track or not.

Hopefully by now you know how to edit a `.goal` file with confidence and run them to report
progress towards your objectives and outcomes. But unless all of your goals are related to page
response time, you'll need to customize `mobius` to meet your needs.


# mobius development guide

Customizing `mobius` for your product is a 3 step process:


#### step 1: create a new .goal file in the goals/ directory

We recommend copying a working example and modifying to meet your needs. For the .goal filename, we recommend naming it
after your objective or problem statement. Something like this:

    $ cp goals/increase_readers.goal goals/improve_quality.goal

Add your objectives, outcomes and the correct target and baseline values. When done, do a *dry run*:

    $ mobius goals/improve_quality.goal --dry-run

Dry runs valid the `.goal` syntax is correct without actually running the scales that measure progress. Ensure your
syntax is valid before moving on.


#### step 3: create a new Scale

Currently the only way to create a custom scale is to write some Ruby code. Specifically you must create a new Ruby class
that extends the `Scale` class and implements a `measure` method. For example, if your .`goal` file contains
"My Custom Scale", the Ruby class would be:

```Ruby
require 'mobiusloop/scale'
require 'mobiusloop/measure'

class MyCustomScale < Scale

  def measure
    total = fetch_your_total
    Measure.new(total)
  end

end
```
This class is saved to `goals/step_definitions/my_custom.scale.rb`. The line `total = fetch_your_total` would be replaced
with your custom logic. The last line `Measure.new(total)` returns a new measure, as required by all Scales.

We recommend writing unit tests around any custom scales you create to ensure they work as expected before integrating with `mobius`.

TODO: Add methods to write custom Scales without writing Ruby. Pre-ship a few common ones.


#### step 3: configure mobius

Certain features of `mobius` are configurable in the `goals/support/config.yml` file. Specifically:

```YAML
measures:
  save: false
```
Setting this to `true` records each `mobius` run's progress in a small `.json` file inside the `goals/measures` directory.
The name of the file is the timestamp of when it was run. If you would like to report on trending
progress of your objectives and outcomes over time, you incorporate these values.

TODO: Identify an relatively easy method to use these to report trending


```YAML
progress:
  good_percent: 10
  bad_percent: 30
```
`mobius` reports progress in green, yellow or red font color to indicate whether you are on track to hit your target by the
target date. This is configurable with the values `good_percent` and `bad_percent`.

It is easiest to explain this with a picture:

![mobius progress graph](/docs/mobius_progress.jpg)

You can adjust `good_percent` and `bad_percent` to adjust how you report progress.


## advanced features

Because `mobius` is an extension of [Cucumber](http://cucumber.io), there are many features in Cucumber that also
exist in `mobius`. A few examples:

**Tags** - Use tags to create logical groups of Objectives, Problems, Outcomes or Key Results that you want run together.
For example, add `@performance` to the line immediately above a definition:

```ruby
@performance
Problem: Slow app response times are causing us to lose customers

```
Then run with this:

    $ mobius --tags @performance

Only those definitions with the @performance tag are run.


## tests

`mobius` is built using a test-first approach. We're proud of our tests, but we're always looking to add more.
If you downloaded the source code to `/workspace/mobiusloop-ruby`, you can run the tests using this command from the source code folder:

    $ rspec spec/mobiusloop/


## further reading

I have personally found [The Cucumber Book](https://pragprog.com/book/hwcuc/the-cucumber-book) a great reference and
 worthy of purchase if you would like to get the most of out `mobius`.
 [Cucumber.io](http://cucumber.io) is also a reference I use.