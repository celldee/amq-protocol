# encoding: utf-8

# THIS IS AN AUTOGENERATED FILE, DO NOT MODIFY
# IT DIRECTLY ! FOR CHANGES, PLEASE UPDATE CODEGEN.PY
# IN THE ROOT DIRECTORY OF THE AMQP-PROTOCOL REPOSITORY.

require_relative "protocol/table.rb"

module AMQP
  module Protocol
    PROTOCOL_VERSION = "0.9.1"
    PREAMBLE = "AMQP\x00\x00\x09\x01"
    DEFAULT_PORT = 5672

    # caching
    EMPTY_STRING = "".freeze

    # @version 0.0.1
    # @return [Array] Collection of subclasses of AMQP::Protocol::Class.
    def self.classes
      Class.classes
    end

    # @version 0.0.1
    # @return [Array] Collection of subclasses of AMQP::Protocol::Method.
    def self.methods
      Method.methods
    end

    class Error < StandardError
      def initialize(message = "AMQP error")
        super(message)
      end
    end

    class Frame
    end

    # We don"t instantiate the following classes,
    # as we don"t actually need any per-instance state.
    # Also, this is pretty low-level functionality,
    # hence it should have a reasonable performance.
    # As everyone knows, garbage collector in MRI performs
    # really badly, which is another good reason for
    # not creating any objects, but only use class as
    # a struct. Creating classes is quite expensive though,
    # but here the inheritance comes handy and mainly
    # as we can"t simply make a reference to a function,
    # we can"t use a hash or an object. I"ve been also
    # considering to have just a bunch of methods, but
    # here"s the problem, that after we"d require this file,
    # all these methods would become global which would
    # be a bad, bad thing to do.
    class Class
      @@classes = Array.new

      def self.method
        @method
      end

      def self.name
        @name
      end

      def self.inherited(base)
        if self == Class
          @@classes << base
        end
      end

      def self.classes
        @@classes
      end
    end

    class Method
      @@methods = Array.new
      def self.method
        @method
      end

      def self.name
        @name
      end

      def self.inherited(base)
        if self == Method
          @@methods << base
        end
      end

      def self.methods
        @@methods
      end

      def self.split_headers(user_headers, properties_set)
        properties, headers = {}, {}
        user_headers.iteritems.each do |key, value|
          if properties_set.has_key?(key)
            properties[key] = value
          else
            headers[key] = value
          end
        end

        return props, headers
      end

      def self.encode_body(body, frame_size)
        # Spec is broken: Our errata says that it does define
        # something, but it just doesn"t relate do method and
        # properties frames. Which makes it, well, suboptimal.
        # https://dev.rabbitmq.com/wiki/Amqp091Errata#section_11
        limit = frame_size - 7 - 1

        Array.new.tap do |array|
          while body
            payload, body = body[0..limit], body[limit..-1]
            array << [0x03, payload]
          end
        end
      end

      # We can return different:
      # - instantiate given subclass of Method
      # - create an OpenStruct object
      # - create a hash
      # - yield params into the block rather than just return
      # @api plugin
      def self.instantiate(*args, &block)
        self.new(*args, &block)
        # or OpenStruct.new(args.first)
        # or args.first
        # or block.call(*args)
      end
    end

    class Connection < Class
      @name = "connection"
      @method = 10

      class Start < Method
        @name = "connection.start"
        @method = 10
        0x000A000A # 10, 10, 655370

        # @return
        def self.decode(data)
        end
      end

      class StartOk < Method
        @name = "connection.start-ok"
        @method = 11
        0x000A000B # 10, 11, 655371

        # @return
        # ["client_properties = nil", "mechanism = "PLAIN"", "response = nil", "locale = "en_US""]
        def self.encode(client_properties, mechanism, response, locale)
          pieces = []
          AMQP::Protocol::Table.encode(pieces, client_properties)
          pieces << mechanism.bytesize.chr
          pieces << mechanism
          pieces << [response.bytesize].pack("N")
          pieces << response
          pieces << locale.bytesize.chr
          pieces << locale
          return pieces.join("")
        end
      end

      class Secure < Method
        @name = "connection.secure"
        @method = 20
        0x000A0014 # 10, 20, 655380

        # @return
        def self.decode(data)
        end
      end

      class SecureOk < Method
        @name = "connection.secure-ok"
        @method = 21
        0x000A0015 # 10, 21, 655381

        # @return
        # ["response = nil"]
        def self.encode(response)
          pieces = []
          pieces << [response.bytesize].pack("N")
          pieces << response
          return pieces.join("")
        end
      end

      class Tune < Method
        @name = "connection.tune"
        @method = 30
        0x000A001E # 10, 30, 655390

        # @return
        def self.decode(data)
        end
      end

      class TuneOk < Method
        @name = "connection.tune-ok"
        @method = 31
        0x000A001F # 10, 31, 655391

        # @return
        # ["channel_max = false", "frame_max = false", "heartbeat = false"]
        def self.encode(channel_max, frame_max, heartbeat)
          pieces = []
          pieces << [channel_max].pack("n")
          pieces << [frame_max].pack("N")
          pieces << [heartbeat].pack("n")
          return pieces.join("")
        end
      end

      class Open < Method
        @name = "connection.open"
        @method = 40
        0x000A0028 # 10, 40, 655400

        # @return
        # ["virtual_host = "/"", "capabilities = """, "insist = false"]
        def self.encode(virtual_host, capabilities, insist)
          pieces = []
          pieces << virtual_host.bytesize.chr
          pieces << virtual_host
          pieces << capabilities.bytesize.chr
          pieces << capabilities
          bit_buffer = 0
          bit_buffer = bit_buffer | (1 << 0) if insist
          return pieces.join("")
        end
      end

      class OpenOk < Method
        @name = "connection.open-ok"
        @method = 41
        0x000A0029 # 10, 41, 655401

        # @return
        def self.decode(data)
        end
      end

      class Close < Method
        @name = "connection.close"
        @method = 50
        0x000A0032 # 10, 50, 655410

        # @return
        def self.decode(data)
        end

        # @return
        # ["reply_code = nil", "reply_text = """, "class_id = nil", "method_id = nil"]
        def self.encode(reply_code, reply_text, class_id, method_id)
          pieces = []
          pieces << [reply_code].pack("n")
          pieces << reply_text.bytesize.chr
          pieces << reply_text
          pieces << [class_id].pack("n")
          pieces << [method_id].pack("n")
          return pieces.join("")
        end
      end

      class CloseOk < Method
        @name = "connection.close-ok"
        @method = 51
        0x000A0033 # 10, 51, 655411

        # @return
        def self.decode(data)
        end

        # @return
        # []
        def self.encode()
          pieces = []
          return pieces.join("")
        end
      end
    end

    class Channel < Class
      @name = "channel"
      @method = 20

      class Open < Method
        @name = "channel.open"
        @method = 10
        0x0014000A # 20, 10, 1310730

        # @return
        # ["out_of_band = """]
        def self.encode(out_of_band)
          pieces = []
          pieces << out_of_band.bytesize.chr
          pieces << out_of_band
          return pieces.join("")
        end
      end

      class OpenOk < Method
        @name = "channel.open-ok"
        @method = 11
        0x0014000B # 20, 11, 1310731

        # @return
        def self.decode(data)
        end
      end

      class Flow < Method
        @name = "channel.flow"
        @method = 20
        0x00140014 # 20, 20, 1310740

        # @return
        def self.decode(data)
        end

        # @return
        # ["active = nil"]
        def self.encode(active)
          pieces = []
          bit_buffer = 0
          bit_buffer = bit_buffer | (1 << 0) if active
          return pieces.join("")
        end
      end

      class FlowOk < Method
        @name = "channel.flow-ok"
        @method = 21
        0x00140015 # 20, 21, 1310741

        # @return
        def self.decode(data)
        end

        # @return
        # ["active = nil"]
        def self.encode(active)
          pieces = []
          bit_buffer = 0
          bit_buffer = bit_buffer | (1 << 0) if active
          return pieces.join("")
        end
      end

      class Close < Method
        @name = "channel.close"
        @method = 40
        0x00140028 # 20, 40, 1310760

        # @return
        def self.decode(data)
        end

        # @return
        # ["reply_code = nil", "reply_text = """, "class_id = nil", "method_id = nil"]
        def self.encode(reply_code, reply_text, class_id, method_id)
          pieces = []
          pieces << [reply_code].pack("n")
          pieces << reply_text.bytesize.chr
          pieces << reply_text
          pieces << [class_id].pack("n")
          pieces << [method_id].pack("n")
          return pieces.join("")
        end
      end

      class CloseOk < Method
        @name = "channel.close-ok"
        @method = 41
        0x00140029 # 20, 41, 1310761

        # @return
        def self.decode(data)
        end

        # @return
        # []
        def self.encode()
          pieces = []
          return pieces.join("")
        end
      end
    end

    class Exchange < Class
      @name = "exchange"
      @method = 40

      class Declare < Method
        @name = "exchange.declare"
        @method = 10
        0x0028000A # 40, 10, 2621450

        # @return
        # ["ticket = false", "exchange = nil", "type = "direct"", "passive = false", "durable = false", "auto_delete = false", "internal = false", "nowait = false", "arguments = {}"]
        def self.encode(ticket, exchange, type, passive, durable, auto_delete, internal, nowait, arguments)
          pieces = []
          pieces << [ticket].pack("n")
          pieces << exchange.bytesize.chr
          pieces << exchange
          pieces << type.bytesize.chr
          pieces << type
          bit_buffer = 0
          bit_buffer = bit_buffer | (1 << 0) if passive
          bit_buffer = bit_buffer | (1 << 1) if durable
          bit_buffer = bit_buffer | (1 << 2) if auto_delete
          bit_buffer = bit_buffer | (1 << 3) if internal
          bit_buffer = bit_buffer | (1 << 4) if nowait
          AMQP::Protocol::Table.encode(pieces, arguments)
          return pieces.join("")
        end
      end

      class DeclareOk < Method
        @name = "exchange.declare-ok"
        @method = 11
        0x0028000B # 40, 11, 2621451

        # @return
        def self.decode(data)
        end
      end

      class Delete < Method
        @name = "exchange.delete"
        @method = 20
        0x00280014 # 40, 20, 2621460

        # @return
        # ["ticket = false", "exchange = nil", "if_unused = false", "nowait = false"]
        def self.encode(ticket, exchange, if_unused, nowait)
          pieces = []
          pieces << [ticket].pack("n")
          pieces << exchange.bytesize.chr
          pieces << exchange
          bit_buffer = 0
          bit_buffer = bit_buffer | (1 << 0) if if_unused
          bit_buffer = bit_buffer | (1 << 1) if nowait
          return pieces.join("")
        end
      end

      class DeleteOk < Method
        @name = "exchange.delete-ok"
        @method = 21
        0x00280015 # 40, 21, 2621461

        # @return
        def self.decode(data)
        end
      end

      class Bind < Method
        @name = "exchange.bind"
        @method = 30
        0x0028001E # 40, 30, 2621470

        # @return
        # ["ticket = false", "destination = nil", "source = nil", "routing_key = """, "nowait = false", "arguments = {}"]
        def self.encode(ticket, destination, source, routing_key, nowait, arguments)
          pieces = []
          pieces << [ticket].pack("n")
          pieces << destination.bytesize.chr
          pieces << destination
          pieces << source.bytesize.chr
          pieces << source
          pieces << routing_key.bytesize.chr
          pieces << routing_key
          bit_buffer = 0
          bit_buffer = bit_buffer | (1 << 0) if nowait
          AMQP::Protocol::Table.encode(pieces, arguments)
          return pieces.join("")
        end
      end

      class BindOk < Method
        @name = "exchange.bind-ok"
        @method = 31
        0x0028001F # 40, 31, 2621471

        # @return
        def self.decode(data)
        end
      end

      class Unbind < Method
        @name = "exchange.unbind"
        @method = 40
        0x00280028 # 40, 40, 2621480

        # @return
        # ["ticket = false", "destination = nil", "source = nil", "routing_key = """, "nowait = false", "arguments = {}"]
        def self.encode(ticket, destination, source, routing_key, nowait, arguments)
          pieces = []
          pieces << [ticket].pack("n")
          pieces << destination.bytesize.chr
          pieces << destination
          pieces << source.bytesize.chr
          pieces << source
          pieces << routing_key.bytesize.chr
          pieces << routing_key
          bit_buffer = 0
          bit_buffer = bit_buffer | (1 << 0) if nowait
          AMQP::Protocol::Table.encode(pieces, arguments)
          return pieces.join("")
        end
      end

      class UnbindOk < Method
        @name = "exchange.unbind-ok"
        @method = 51
        0x00280033 # 40, 51, 2621491

        # @return
        def self.decode(data)
        end
      end
    end

    class Queue < Class
      @name = "queue"
      @method = 50

      class Declare < Method
        @name = "queue.declare"
        @method = 10
        0x0032000A # 50, 10, 3276810

        # @return
        # ["ticket = false", "queue = """, "passive = false", "durable = false", "exclusive = false", "auto_delete = false", "nowait = false", "arguments = {}"]
        def self.encode(ticket, queue, passive, durable, exclusive, auto_delete, nowait, arguments)
          pieces = []
          pieces << [ticket].pack("n")
          pieces << queue.bytesize.chr
          pieces << queue
          bit_buffer = 0
          bit_buffer = bit_buffer | (1 << 0) if passive
          bit_buffer = bit_buffer | (1 << 1) if durable
          bit_buffer = bit_buffer | (1 << 2) if exclusive
          bit_buffer = bit_buffer | (1 << 3) if auto_delete
          bit_buffer = bit_buffer | (1 << 4) if nowait
          AMQP::Protocol::Table.encode(pieces, arguments)
          return pieces.join("")
        end
      end

      class DeclareOk < Method
        @name = "queue.declare-ok"
        @method = 11
        0x0032000B # 50, 11, 3276811

        # @return
        def self.decode(data)
        end
      end

      class Bind < Method
        @name = "queue.bind"
        @method = 20
        0x00320014 # 50, 20, 3276820

        # @return
        # ["ticket = false", "queue = nil", "exchange = nil", "routing_key = """, "nowait = false", "arguments = {}"]
        def self.encode(ticket, queue, exchange, routing_key, nowait, arguments)
          pieces = []
          pieces << [ticket].pack("n")
          pieces << queue.bytesize.chr
          pieces << queue
          pieces << exchange.bytesize.chr
          pieces << exchange
          pieces << routing_key.bytesize.chr
          pieces << routing_key
          bit_buffer = 0
          bit_buffer = bit_buffer | (1 << 0) if nowait
          AMQP::Protocol::Table.encode(pieces, arguments)
          return pieces.join("")
        end
      end

      class BindOk < Method
        @name = "queue.bind-ok"
        @method = 21
        0x00320015 # 50, 21, 3276821

        # @return
        def self.decode(data)
        end
      end

      class Purge < Method
        @name = "queue.purge"
        @method = 30
        0x0032001E # 50, 30, 3276830

        # @return
        # ["ticket = false", "queue = nil", "nowait = false"]
        def self.encode(ticket, queue, nowait)
          pieces = []
          pieces << [ticket].pack("n")
          pieces << queue.bytesize.chr
          pieces << queue
          bit_buffer = 0
          bit_buffer = bit_buffer | (1 << 0) if nowait
          return pieces.join("")
        end
      end

      class PurgeOk < Method
        @name = "queue.purge-ok"
        @method = 31
        0x0032001F # 50, 31, 3276831

        # @return
        def self.decode(data)
        end
      end

      class Delete < Method
        @name = "queue.delete"
        @method = 40
        0x00320028 # 50, 40, 3276840

        # @return
        # ["ticket = false", "queue = nil", "if_unused = false", "if_empty = false", "nowait = false"]
        def self.encode(ticket, queue, if_unused, if_empty, nowait)
          pieces = []
          pieces << [ticket].pack("n")
          pieces << queue.bytesize.chr
          pieces << queue
          bit_buffer = 0
          bit_buffer = bit_buffer | (1 << 0) if if_unused
          bit_buffer = bit_buffer | (1 << 1) if if_empty
          bit_buffer = bit_buffer | (1 << 2) if nowait
          return pieces.join("")
        end
      end

      class DeleteOk < Method
        @name = "queue.delete-ok"
        @method = 41
        0x00320029 # 50, 41, 3276841

        # @return
        def self.decode(data)
        end
      end

      class Unbind < Method
        @name = "queue.unbind"
        @method = 50
        0x00320032 # 50, 50, 3276850

        # @return
        # ["ticket = false", "queue = nil", "exchange = nil", "routing_key = """, "arguments = {}"]
        def self.encode(ticket, queue, exchange, routing_key, arguments)
          pieces = []
          pieces << [ticket].pack("n")
          pieces << queue.bytesize.chr
          pieces << queue
          pieces << exchange.bytesize.chr
          pieces << exchange
          pieces << routing_key.bytesize.chr
          pieces << routing_key
          AMQP::Protocol::Table.encode(pieces, arguments)
          return pieces.join("")
        end
      end

      class UnbindOk < Method
        @name = "queue.unbind-ok"
        @method = 51
        0x00320033 # 50, 51, 3276851

        # @return
        def self.decode(data)
        end
      end
    end

    class Basic < Class
      @name = "basic"
      @method = 60

      PROPERTIES = [
        :content_type, # shortstr
        :content_encoding, # shortstr
        :headers, # table
        :delivery_mode, # octet
        :priority, # octet
        :correlation_id, # shortstr
        :reply_to, # shortstr
        :expiration, # shortstr
        :message_id, # shortstr
        :timestamp, # timestamp
        :type, # shortstr
        :user_id, # shortstr
        :app_id, # shortstr
        :cluster_id, # shortstr
      ]

      # 1 << 15
      def self.encode_content_type(value)
        pieces = []
        pieces << result.bytesize.chr
        pieces << result
        [0, 0x8000, result]
      end

      # 1 << 14
      def self.encode_content_encoding(value)
        pieces = []
        pieces << result.bytesize.chr
        pieces << result
        [1, 0x4000, result]
      end

      # 1 << 13
      def self.encode_headers(value)
        pieces = []
        AMQP::Protocol::Table.encode(pieces, result)
        [2, 0x2000, result]
      end

      # 1 << 12
      def self.encode_delivery_mode(value)
        pieces = []
        pieces << [result].pack("B")
        [3, 0x1000, result]
      end

      # 1 << 11
      def self.encode_priority(value)
        pieces = []
        pieces << [result].pack("B")
        [4, 0x0800, result]
      end

      # 1 << 10
      def self.encode_correlation_id(value)
        pieces = []
        pieces << result.bytesize.chr
        pieces << result
        [5, 0x0400, result]
      end

      # 1 << 9
      def self.encode_reply_to(value)
        pieces = []
        pieces << result.bytesize.chr
        pieces << result
        [6, 0x0200, result]
      end

      # 1 << 8
      def self.encode_expiration(value)
        pieces = []
        pieces << result.bytesize.chr
        pieces << result
        [7, 0x0100, result]
      end

      # 1 << 7
      def self.encode_message_id(value)
        pieces = []
        pieces << result.bytesize.chr
        pieces << result
        [8, 0x0080, result]
      end

      # 1 << 6
      def self.encode_timestamp(value)
        pieces = []
        pieces << [result].pack(">Q")
        [9, 0x0040, result]
      end

      # 1 << 5
      def self.encode_type(value)
        pieces = []
        pieces << result.bytesize.chr
        pieces << result
        [10, 0x0020, result]
      end

      # 1 << 4
      def self.encode_user_id(value)
        pieces = []
        pieces << result.bytesize.chr
        pieces << result
        [11, 0x0010, result]
      end

      # 1 << 3
      def self.encode_app_id(value)
        pieces = []
        pieces << result.bytesize.chr
        pieces << result
        [12, 0x0008, result]
      end

      # 1 << 2
      def self.encode_cluster_id(value)
        pieces = []
        pieces << result.bytesize.chr
        pieces << result
        [13, 0x0004, result]
      end

      def self.encode_properties(body_size, properties)
        pieces = Array.new(14) { AMQP::Protocol::EMPTY_STRING }
        flags = 0

        properties.each do |key, value|
          i, f, result = self.send(:"encode_#{key}", value)
          flags |= f
          pieces[i] = result
        end

        result = [CLASS_BASIC, 0, body_size, flags].pack("!HHQH")
        [0x02, result, pieces.join("")].join("")
      end

      #def self.decode_properties
      #  print "def %s(data, offset):" % (c.decode,)
      #  print "    props = {}"
      #  print "    flags, = struct.unpack_from("!H", data, offset)"
      #  print "    offset += 2"
      #  print "    assert (flags & 0x01) == 0"
      #  for i, f in enumerate(c.fields):
      #      print "    if (flags & 0x%04x): # 1 << %i" % (1 << (15-i), 15-i)
      #      fields = codegen_helpers.UnpackWrapper()
      #      fields.add(f.n, f.t)
      #      fields.do_print(" "*8, "props["%s"]")
      #  print "    return props, offset"
      #end

      class Qos < Method
        @name = "basic.qos"
        @method = 10
        0x003C000A # 60, 10, 3932170

        # @return
        # ["prefetch_size = false", "prefetch_count = false", "global = false"]
        def self.encode(prefetch_size, prefetch_count, global)
          pieces = []
          pieces << [prefetch_size].pack("N")
          pieces << [prefetch_count].pack("n")
          bit_buffer = 0
          bit_buffer = bit_buffer | (1 << 0) if global
          return pieces.join("")
        end
      end

      class QosOk < Method
        @name = "basic.qos-ok"
        @method = 11
        0x003C000B # 60, 11, 3932171

        # @return
        def self.decode(data)
        end
      end

      class Consume < Method
        @name = "basic.consume"
        @method = 20
        0x003C0014 # 60, 20, 3932180

        # @return
        # ["ticket = false", "queue = nil", "consumer_tag = """, "no_local = false", "no_ack = false", "exclusive = false", "nowait = false", "arguments = {}"]
        def self.encode(ticket, queue, consumer_tag, no_local, no_ack, exclusive, nowait, arguments)
          pieces = []
          pieces << [ticket].pack("n")
          pieces << queue.bytesize.chr
          pieces << queue
          pieces << consumer_tag.bytesize.chr
          pieces << consumer_tag
          bit_buffer = 0
          bit_buffer = bit_buffer | (1 << 0) if no_local
          bit_buffer = bit_buffer | (1 << 1) if no_ack
          bit_buffer = bit_buffer | (1 << 2) if exclusive
          bit_buffer = bit_buffer | (1 << 3) if nowait
          AMQP::Protocol::Table.encode(pieces, arguments)
          return pieces.join("")
        end
      end

      class ConsumeOk < Method
        @name = "basic.consume-ok"
        @method = 21
        0x003C0015 # 60, 21, 3932181

        # @return
        def self.decode(data)
        end
      end

      class Cancel < Method
        @name = "basic.cancel"
        @method = 30
        0x003C001E # 60, 30, 3932190

        # @return
        # ["consumer_tag = nil", "nowait = false"]
        def self.encode(consumer_tag, nowait)
          pieces = []
          pieces << consumer_tag.bytesize.chr
          pieces << consumer_tag
          bit_buffer = 0
          bit_buffer = bit_buffer | (1 << 0) if nowait
          return pieces.join("")
        end
      end

      class CancelOk < Method
        @name = "basic.cancel-ok"
        @method = 31
        0x003C001F # 60, 31, 3932191

        # @return
        def self.decode(data)
        end
      end

      class Publish < Method
        @name = "basic.publish"
        @method = 40
        0x003C0028 # 60, 40, 3932200

        # @return
        # ["ticket = false", "exchange = """, "routing_key = """, "mandatory = false", "immediate = false", "user_headers = nil", "payload = """, "frame_size = nil"]
        def self.encode(ticket, exchange, routing_key, mandatory, immediate, user_headers, payload, frame_size)
          pieces = []
          pieces << [ticket].pack("n")
          pieces << exchange.bytesize.chr
          pieces << exchange
          pieces << routing_key.bytesize.chr
          pieces << routing_key
          bit_buffer = 0
          bit_buffer = bit_buffer | (1 << 0) if mandatory
          bit_buffer = bit_buffer | (1 << 1) if immediate
          return pieces.join("")
        end
      end

      class Return < Method
        @name = "basic.return"
        @method = 50
        0x003C0032 # 60, 50, 3932210

        # @return
        def self.decode(data)
        end
      end

      class Deliver < Method
        @name = "basic.deliver"
        @method = 60
        0x003C003C # 60, 60, 3932220

        # @return
        def self.decode(data)
        end
      end

      class Get < Method
        @name = "basic.get"
        @method = 70
        0x003C0046 # 60, 70, 3932230

        # @return
        # ["ticket = false", "queue = nil", "no_ack = false"]
        def self.encode(ticket, queue, no_ack)
          pieces = []
          pieces << [ticket].pack("n")
          pieces << queue.bytesize.chr
          pieces << queue
          bit_buffer = 0
          bit_buffer = bit_buffer | (1 << 0) if no_ack
          return pieces.join("")
        end
      end

      class GetOk < Method
        @name = "basic.get-ok"
        @method = 71
        0x003C0047 # 60, 71, 3932231

        # @return
        def self.decode(data)
        end
      end

      class GetEmpty < Method
        @name = "basic.get-empty"
        @method = 72
        0x003C0048 # 60, 72, 3932232

        # @return
        def self.decode(data)
        end
      end

      class Ack < Method
        @name = "basic.ack"
        @method = 80
        0x003C0050 # 60, 80, 3932240

        # @return
        # ["delivery_tag = false", "multiple = false"]
        def self.encode(delivery_tag, multiple)
          pieces = []
          pieces << [delivery_tag].pack(">Q")
          bit_buffer = 0
          bit_buffer = bit_buffer | (1 << 0) if multiple
          return pieces.join("")
        end
      end

      class Reject < Method
        @name = "basic.reject"
        @method = 90
        0x003C005A # 60, 90, 3932250

        # @return
        # ["delivery_tag = nil", "requeue = true"]
        def self.encode(delivery_tag, requeue)
          pieces = []
          pieces << [delivery_tag].pack(">Q")
          bit_buffer = 0
          bit_buffer = bit_buffer | (1 << 0) if requeue
          return pieces.join("")
        end
      end

      class RecoverAsync < Method
        @name = "basic.recover-async"
        @method = 100
        0x003C0064 # 60, 100, 3932260

        # @return
        # ["requeue = false"]
        def self.encode(requeue)
          pieces = []
          bit_buffer = 0
          bit_buffer = bit_buffer | (1 << 0) if requeue
          return pieces.join("")
        end
      end

      class Recover < Method
        @name = "basic.recover"
        @method = 110
        0x003C006E # 60, 110, 3932270

        # @return
        # ["requeue = false"]
        def self.encode(requeue)
          pieces = []
          bit_buffer = 0
          bit_buffer = bit_buffer | (1 << 0) if requeue
          return pieces.join("")
        end
      end

      class RecoverOk < Method
        @name = "basic.recover-ok"
        @method = 111
        0x003C006F # 60, 111, 3932271

        # @return
        def self.decode(data)
        end
      end
    end
  end
end
