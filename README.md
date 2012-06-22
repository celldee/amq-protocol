# What is amq-protocol.

amq-protocol is an AMQP 0.9.1 serialization library for Ruby. It is not an
AMQP client: amq-protocol only handles serialization and deserialization.
If you want to write your own AMQP client, this gem can help you with that.

## How does amq-protocol relate to amqp gem, amq-client and libraries like bunny?

See [this page about AMQP gems family](https://github.com/ruby-amqp/amq-client/blob/master/README.textile)


## Installation

    gem install amq-protocol


## Development

Make sure you have Python and the mako templating package installed. amq-protocol uses RabbitMQ protocol
code generation library that is in Python, so there is some Python involved in the build. Don't fret.

To regenerate `lib/amq/protocol/client.rb`, run

    ./generate.rb

## Maintainer Information

amq-protocol is maintained by [Michael Klishin](https://github.com/michaelklishin).


## Links

 * [Continous integration server](http://travis-ci.org/#!/ruby-amqp/amq-protocol)
 * [Ruby AMQP mailing list](http://groups.google.com/group/ruby-amqp)
 * [Issue tracker](http://github.com/ruby-amqp/amq-protocol/issues)
