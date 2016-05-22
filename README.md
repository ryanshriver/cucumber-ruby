# building the right things with mobiusloop

`mobiusloop` provides continuous feedback to people on whether they are **building the right things**, not just **building things right**.

Most product development tools focus on **building things right** meaning on time, on budget and with high quality.
`mobiusloop` is different. It uses a simple language to define the desired business and product goals, such as Increase
Customer Conversion or Improve App Responsiveness. Then `mobiusloop` uses automation to measure and report on progress
towards these goals daily, weekly or whenever you want.

With `mobiusloop` teams get realtime feedback on whether their new features are delivering the expected value. Leaders get
clear visibility on whether their investments are delivering the desired return. Everyone gets feedback on whether they are
**building the right things**.

Use `mobiusloop` with methods like [Objectives and Key Results (OKR's)](https://www.amazon.com/Radical-Focus-Achieving-Important-Objectives-ebook/dp/B01BFKJA0Y)
and [Mobius](http://mobiusloop.com) to define and measure the value of your product or service.


## how it works

Today many teams write automated feature tests using open source tools like [Cucumber](http://cucumber.io). They write these
tests in a simple, readable format using the [Gherkin](https://cucumber.io/docs/reference) language. Whenever these tests are run, teams get realtime feedback
on the quality of their product.

`mobiusloop` takes this concept and applies it to strategic business and product goals. Instead of tests that report on
product quality when run, `mobiusloop` reports on progress towards desired goals.

Under the covers `mobiusloop` is built on [Cucumber](http://cucumber.io) and consists of three main parts:
 1. `.goal` files
 1. step definitions
 1. custom `Scale`'s


#### 1. `.goal` files
To start, leaders and teams agree on their objectives and the measurable outcomes that define success.
Frameworks like [Objectives and Key Results (OKR's)](https://www.amazon.com/Radical-Focus-Achieving-Important-Objectives-ebook/dp/B01BFKJA0Y)
and [Mobius](http://mobiusloop.com) encourage qualitative statements (problems or objectives) together with quantitative
measures of success (outcomes or key results).

Using `mobiusloop`, leaders and teams collaboratively write these in a `.goal` text file. Here's an example:

```ruby
Objective: Reach a million paying customers by Q3 2016!

  Key Result: Increase Journal Readership
    Given a baseline of 500,000 readers on Oct 1, 2015
    And a target of 1,000,000 readers by Oct 1, 2016
    When we measure progress with "Total Readers Scale"
    Then report progress towards target
```
Here's another one:

```ruby
Problem: Slow app response times are causing us to lose customers

  Outcome: Improve App Responsiveness
    Given a baseline of 4.5 seconds average response time on May 1, 2016
    And a target of 1.5 seconds average response time by Jun 30, 2016
    When we measure progress with "Peak User Performance Scale"
    Then report progress towards target
```
The syntax is based [Gherkin](https://cucumber.io/docs/reference), the language used to write Cucumber acceptance tests.
`mobiusloop` introduces a four new keywords to Gherkin: **Objective**, **Problem**, **Outcome** and **Key Result**.

Each `.goal` file contains **one** Objective or Problem and **one or more** Outcomes or Key Results.

When the `.goal` files are run from a command line, they report progress towards your targets like this:

```ruby
Objective: Top a million paying customers by Q3 2016!

  Key Result: Increase Journal Readership to 1,000,000
    Given a baseline of 500000 readers on "Oct 1, 2015"
    And a target of 1000000 readers by "Oct 1, 2016"
    When we measure progress with "Total Readers Scale"
      Success! found 820,000 readers in 1.2 seconds!
    Then report progress towards targets
      Hooray! You are on track!
      64% progress to target using 61% of the time (222 days)
      36% remaining to target in 143 days
````

Progress is reported as text or optionally saved in a [web page](results.html) for sharing.

With `mobiusloop` teams can measure progress towards their goals daily, weekly, monthly or whatever cadence makes sense.
Integrating `mobiusloop` into your continuous delivery pipeline helps measure the impacts of each new release on your outcomes or key results.


#### 2. step definitions
Under the covers, `mobiusloop` is built on a forked copy of [cucumber-ruby](https://github.com/cucumber/cucumber-ruby).
It uses Gherkin to parse the `.goal` file and call Cucumber [step definitions](https://github.com/cucumber/cucumber/wiki/Step-Definitions).
`mobiusloop` ships with one step definition [mobius_steps.rb](lib/mobiusloop/mobius_steps.rb) that can be modified or extended.

In `mobius_steps.rb`, the lines beginning with `Given` save the baseline and target values.
The line beginning with `When` creates an `Outcome` with a custom `Scale`, sets the baselines and targets, then calls
the `measure` method to perform the measurement. The line beginning with `Then` reports the progress towards targets.

This `Given, When, Then` syntax is identical to Gherkin, easing the learning curve for teams already using Cucumber.
Teams can either use `mobius_steps.rb` or create their own step definitions.


#### 3. custom `Scale`'s

At creation time, each outcome (or key result) is associated with a custom `Scale` of measure.
`Scale`'s are the code that collects your data in your environment to report progress.
`mobiusloop` ships with a few example scales, however teams are encouraged to create custom scales to meet their needs.

To create a Scale, create a new Ruby class that extends `Scale` and then implement the `measure` method. Next, update the `.goal`
 file to reference your new `Scale` class. When `mobiusloop` parses this line:

```we measure progress with "Total Readers Scale"```

it creates a new instance of the Ruby class `TotalReadersScale` and calls the `measure` method, which returns a new `Measure`.

In this example, you would implement the method `collect_total_readers` with your custom logic.

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


## getting started

Adding `mobiusloop` to your product is easy, but requires some command-line chops.
If this section looks like Greek, then as nicely as possible ask a developer on your team for help.

**Note:** Currently only Ruby on Linux and OSX are tested platforms. Windows will be added in the future.

If [Ruby](https://www.ruby-lang.org/en/), [gem](https://rubygems.org) and [bundle](http://bundler.io) are not installed, install them first.

Then install `mobiusloop` with this command:

    $ gem install mobiusloop

Once installed, create a symbolic link for the `mobiusloop` command. First locate your ruby executable path:

    $ gem env

Look for the value of `EXECUTABLE DIRECTORY`, something like `/usr/local/Cellar/ruby/2.2.3/bin/`.
Then create a symbolic link:

    $ ln -s </path/to/executable/directory/mobiusloop /usr/local/bin/mobiusloop

**TODO:** Find a way to create symbolic link as part of gem install to remove this manual step


## adding mobiusloop to your app

To create and run your own goals, let's start with a working example and modify it.

Change to the root directory of your app and run `mobiusloop`:

    $ cd product_home
    $ mobiusloop

You get feedback that `mobiousloop` is not initialized. So let's do that:

    $ mobiusloop --init

`mobiusloop` just created a `goals/` directory and put some files in there. Let's run our example:

    $ mobiusloop

If all goes well, you get feedback that `mobiusloop` is running for your product! Now let's customize it for your needs.


## create your first .goal

First, open `goals/increase_readers.goal` in a text editor, change the baseline or target value, save and run again.
Did you notice changes in the progress and status? Change the baseline and target dates and try again. Getting the hang of it?

Now let's pretend you have a product outcome to **improve response time** for your product from 4.5 seconds to 1 second.
Start by copying our working example:

    $ cp goals/increase_readers.goal goals/improve_response_time.goal


#### create objectives and outcomes

Open the new `improve_response_time.goal` in your text editor and make some changes:

 - Update `Objective:` to reflect our new goal. How about <i>Improve our digital customer experience this year</i>.
 - Let's only start with one `Outcome`, so delete from `Outcome: Increase Published Articles by 25%` to the end of the file
 - Now update your `Outcome:` keeping it short and sweet. Something like <i>Improve Response Time</i>

Now save the file and run again:

    $ mobiusloop

This runs all the `.goal` files to `goals/` folder. We can just run our new one with this command:

    $ mobiusloop goals/improve_response_time.goal

We don't need the example anymore, so let's remove it:

    $ rm goals/increase_readers.goal


#### define baselines and targets

Open `improve_response_time.goal` again and let's update the baselines and targets.
Let's pretend as of October 1, 2015 your app's home page takes 5 seconds to load. That's your baseline. Make a change:

 - In the row starting with `Given`, change 50000 to 5 and "readers" to "seconds"

Your product owner has said <i>sub-second</i> is their goal. That's your target. Make another change:

 - In the row starting with `And`, change 1000000 to 1 and "readers" to "second"

Now save the file and run again:

    $ mobiusloop

This works, but we have 820,000 seconds! That's not right, so let's fix it.


#### define scales

Open `improve_response_time.goal` again and let's change the scale to record response times, not total readers.

 - In the row starting with `When`, change "Total Readers Scale" to "Page Response Scale"

Now save the file and run again.

    $ mobiusloop

Wow, much better! The "Page Response Scale" requested google.com and compared the response time to your target.

How did you do? Did you hit the target?


## developing with mobiusloop

Hopefully by now you're getting the hang of `mobiusloop`. During development there are three basic steps:


#### step 1: create a new .goal file in the goals/ directory

You can copy an example or start from scratch. When done, do a dry run to ensure your syntax is valid:

    $ mobiusloop goals/your_objective.goal --dry-run

Replacing `your_objective.goal` with your filename. If there's any syntax problems, fix them and run again until you get a clean run.


#### step 2: optionally create a step definition

`mobiusloop` ships with one step definition `goals/step_definitions/mobius_steps.rb`. If you write your objectives,
problems, outcomes and key results in the format above there's no need to create one. However if you want to create your own
format, you will need to create a custom step definition. To verify, run:

    $ mobiusloop goals/your_objective.goal

If `mobiusloop` cannot find a matching step definition for your `.goal` file, it will tell you the step definition to create.
Copy and paste this into a new file `your_name_steps.rb` and save it to the `goals/step_definitions` folder. For more
info on step definitions, see [Cucumber's reference](https://cucumber.io/docs/reference#step-definitions).


#### step 3: create a new Scale

Create a new Ruby class to perform the measurement. For example, if your .`goal` file contains "My Custom Scale", the Ruby class would be:

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
This code lives in `my_custom.scale.rb`.
Replace the line `total = fetch_your_total` with your custom logic.
The last line `Measure.new(total)` returns a new measure.

We recommend writing unit tests around any custom scales you create to ensure they work as expected before integrating with `mobiusloop`

To run a single `.goal`, try this:

    $ mobiusloop goals/your_objective.goal

Where `your_objective.goal` is the name of your custom goal. You can run all the `.goal` files in `/goals` folder with this:

    $ mobiusloop


## advanced features

Because `mobiusloop` is an extension of [Cucumber](http://cucumber.io), there are many features in Cucumber that also
exist in `mobiusloop`. A few examples:

**Tags** - Use tags to create logical groups of Objectives, Problems, Outcomes or Key Results that you want run together.
For example, adding `@mytag` to the line immediately above a definition and running it with:

    $ mobiusloop --tags @mytag

Will only run those Objectives, Problems, Outcomes or Key Results associated with that tag.

**Reports** - By default `mobiusloop` outputs the results to the command line. But you can also output reports in HTML,
JSON or other formats. See [Cucumber reports](https://cucumber.io/docs/reference#reports) for more details.


## Testing

`mobiusloop` is built using a test-first approach. We're proud of our tests, but we're always looking to add more.
If you downloaded the source code to `/workspace/mobiusloop-ruby`, you can run the tests using this command from the source code folder:

    $ rake spec


## Report Defects

See a missing test or found a defect? [Let us know](https://github.com/ryanshriver/mobius/issues) by creating a new issue.


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/mobius.

