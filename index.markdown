---
layout: default
title: Model Plus
---

The <a href="http://github.com/ffmike/model_plus">Model Plus</a> project is an attempt to improve on the default
Rails model generator.

Its starting point is a <a href="http://rails.lighthouseapp.com/projects/8994/tickets/1315-extend-model-generator-to-create-association-declarations">patch</a>
that I wrote to extend the built-in model generator to create association declarations. That patch has been tabled in favor of
writing a proof-of-concept plugin instead.

Here's the current usage instructions:

Stubs out a new model. Pass the model name, either CamelCased or
under\_scored, and an optional list of attribute pairs as arguments.

Attribute pairs are column\_name:sql\_type arguments specifying the
model's attributes. Timestamps are added by default, so you don't have to
specify them by hand as 'created\_at:datetime updated\_at:datetime'.

You don't have to think up every attribute up front, but it helps to
sketch out a few so you can start working with the model immediately.

If you include an attribute with a type of :references, :belongs\_to,
:has\_many, :has\_one, or :has\_and\_belongs\_to\_many, the model will contain
the appropriate association declaration.

You can also decorate a type with suffixes that specify further code
generation in the model:

<pre><code>
    title:string+a     => Adds to an attr_accessible list
    title:string+p     => validates_presence_of :title
    posted:boolean+ap  => attr_accessible and 
       validates_inclusion_of :posted :in => [true, false]
</code></pre>

This generates a model class in app/models, a unit test in test/unit,
a test fixture in test/fixtures/singular/_name.yml, and a migration in
db/migrate.
