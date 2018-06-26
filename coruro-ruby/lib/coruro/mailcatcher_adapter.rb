require 'net/http'
require 'json'
require 'open3'
require 'singleton'
require_relative 'unbundle'

class Coruro
  # Translates between Curoro and Mailcatcher's API
  class MailcatcherAdapter

    attr_accessor :runner, :timeout, :config
    extend Forwardable
    def_delegators :runner, :stop
    def_delegators :config, :http_root
    def initialize(timeout:, config:)
      self.timeout = timeout
      self.config = Configuration.new(config)
    end

    def all
      messages
    end

    def where(to: nil, from: nil, subject: nil)
      result = []; start_time = Time.now.to_f
      while (result.empty? && (Time.now.to_f - start_time) <=  timeout)
        result = messages.select do |message|
          match?(to, message[:recipients]) ||
          match?(from, message[:sender]) ||
          match?(subject, message[:subject])
        end.map(&method(:find_by))
      end
      result
    end

    def match?(query, value)
      return false if query.nil?
      return value.any? { |child| match?(query, child) } if value.respond_to?(:any?)
      return query.match?(value) if query.respond_to?(:match?)
      return !query.match(value).nil? if query.respond_to?(:match)
      raise ArgumentError, "Query #{query} must respond to `match?` or Value #{value} must respond to `any?`"
    end

    def up?
      runner.up?(config)
    end

    def start
      runner.start(config)
    end

    def runner
      @_runner ||= Runner.instance
    end

    private def messages
      JSON.parse(Net::HTTP.get(URI("#{http_root}/messages")), symbolize_names: true)
    end

    private def raw_message(message_id)
      Net::HTTP.get(URI("#{http_root}/messages/#{message_id}.eml"))
    end


    private def find_by(attributes)
      message = Message.new(Mail.new(raw_message(attributes[:id])))
      message.id = attributes[:id]
      message
    end

    # Allows for launching and terminating mailcatcher programmaticaly
    class Runner
      include Singleton
      attr_accessor :stdin, :stdout, :stderr, :thread


      def start(config)
        return if up?(config)
        new_env = Unbundle.all(ENV)
        self.stdin, self.stdout, self.stderr, self.thread =
          Open3.popen3(new_env, 'mailcatcher -f --ip=0.0.0.0', { unsetenv_others:true })

        debug_stream(:stdout, config: config)
        debug_stream(:stderr, config: config)
      end

      def up?(config)
        response = Net::HTTP.get_response(URI("#{config.http_root}"))
        response.is_a?(Net::HTTPSuccess)
      rescue Errno::ECONNREFUSED, Errno::EADDRNOTAVAIL => _
        false
      end

      def stop

        return unless self.thread
        streams.each do |(_, stream)|
          stream.close
        end
        `kill -9 #{ thread[:pid] }`
      end

      private def debug_stream(stream_name, config:)
        if config.expose_stream?(stream_name)
          stream_target = config.expose_streams[stream_name]
          stream = streams[stream_name]
          Thread.new {
            while line = stream.gets do
              stream_target.puts(line)
            end
          }
        end
      end


      private def streams
        { stderr: stderr, stdout: stdout, stdin: stdin }
      end
    end

    class Configuration
      attr_accessor :config
      def initialize(config)
        self.config = config
      end

      def http_root
        config.fetch(:http_root, 'http://localhost:1080')
      end

      def expose_stream?(stream)
        !expose_streams[stream].nil?
      end

      def expose_streams
        config.fetch(:expose_streams, {})
      end
    end
  end
end
