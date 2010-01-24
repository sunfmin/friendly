require 'colored'
require 'logger'

module Friendly
  class Logger < ::Logger
    def initialize(*args)
      super
      @default_formatter   = Formatter.new
      self.datetime_format = "%Y-%d-%m %H:%M:%S"
    end

    class Formatter < ::Logger::Formatter
      Format = "[%s] [%s]: %s\n"

      def call(severity, time, progname, msg)
        output_message = msg2str(msg)
        Format % [format_datetime(time), severity, output_message]
      end
    end 
  end
end
