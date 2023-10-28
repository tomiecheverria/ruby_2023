# frozen_string_literal: true

require_relative "ruby_2023/version"

module Ruby2023
  class Error < StandardError; end
  module Countable
    module ClassMethods
      def count_invocations_of(*method_names)
        method_names.each do |method_name|
          alias_method "orig_#{method_name}", method_name
          define_method(method_name) do
            invocation_count[method_name] += 1
            send("orig_#{method_name}")
          end
        end
      end
    end
  
    def self.included(base)
      base.extend(ClassMethods)
    end
  
    def invocation_count
      @invocation_count ||= Hash.new(0)
    end
  
    def invoked?(method_name)
      invoked(method_name) > 0
    end
  
    def invoked(method_name)
      invocation_count[method_name]
    end
  end
end
