require 'net/http'
require 'json'
require 'open3'
require 'singleton'

class Coruro
  class Configuration
    attr_accessor :config
    def initialize(config)
      self.config = config
    end

    def http_root
      self.config[:http_root] || 'http://localhost:1080'
    end
  end
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
      while (result.empty? || (Time.now.to_f - start_time) <=  timeout)
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
      return query.match?(value) if query.respond_to?(:match?) && !value.respond_to?(:any?)
      return value.any? { |child| match?(query, child) } if value.respond_to?(:any?)
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
      attr_accessor :stdin, :stdout, :stderr, :thread, :config


      def start(config)
        return if up?(config)
        self.stdin, self.stdout, self.stderr, self.thread =
          Open3.popen3({ "PATH" => ENV['PATH'] }, 'mailcatcher -f', { unsetenv_others:true })

        p "Status", self.thread.status
      end

      def up?(config)
        response = Net::HTTP.get_response(URI("#{config.http_root}"))
        response.is_a?(Net::HTTPSuccess)
      rescue Errno::ECONNREFUSED, Errno::EADDRNOTAVAIL => _
        false
      end

      def stop
        return unless self.thread
        self.stdin.close
        self.stdout.close
        self.stderr.close
        `kill -9 #{ thread[:pid] }`
      end
    end
  end
end
