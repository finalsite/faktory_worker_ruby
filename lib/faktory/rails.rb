# frozen_string_literal: true
module Faktory
  class Rails < ::Rails::Engine
    # This hook happens after `Rails::Application` is inherited within
    # config/application.rb and before config is touched, usually within the
    # class block. Definitely before config/environments/*.rb and
    # config/initializers/*.rb.
    config.before_configuration do
      if defined?(::ActiveJob)
        require 'active_job/queue_adapters/faktory_adapter'
      end
    end

    config.after_initialize do
      # This hook happens after all initializers are run, just before returning
      # from config/environment.rb back to faktory/cli.rb.
      # We have to add the reloader after initialize to see if cache_classes has
      # been turned on.
      #
      # None of this matters on the client-side, only within the Faktory executor itself.
      #
    end

    class Reloader
      def initialize(app = ::Rails.application)
        @app = app
      end

      def call
        @app.reloader.wrap do
          yield
        end
      end

      def inspect
        "#<Faktory::Rails::Reloader @app=#{@app.class.name}>"
      end
    end
  end if defined?(::Rails)
end
