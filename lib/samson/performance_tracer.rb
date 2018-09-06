# frozen_string_literal: true

module Samson
  module PerformanceTracer
    class << self
      def included(clazz)
        clazz.extend ClassMethods
      end

      def trace_execution_scoped(scope_name)
        SamsonNewRelic.trace_method_execution_scope(scope_name) do
          SamsonDatadogTracer::APM.trace_method_execution_scope(scope_name) do
            yield
          end
        end
      end
    end

    # Common class methods for Newrelic and Datadog.
    module ClassMethods
      def add_method_tracers(*methods)
        Samson::Hooks.fire(:performance_tracer, self, methods)
      end

      # TODO: Add asynchronous tracer for Datadog.
      def add_asynchronous_tracer(method, options)
        Samson::Hooks.fire(:asynchronous_performance_tracer, self, method, options)
      end
    end
  end
end
