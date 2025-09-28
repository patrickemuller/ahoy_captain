require "ostruct"
require "ahoy_captain/version"
require "ahoy_captain/railtie"
require "ahoy_captain/engine"
require "ahoy_captain/goals"
require "ahoy_captain/funnels"
require "ahoy_captain/configuration"
require "ahoy_captain/predicate_label"
require 'ahoy_captain/ahoy/visit_methods'
require 'ahoy_captain/ahoy/event_methods'

require 'importmap-rails'

module AhoyCaptain
  class << self
    attr_accessor :configuration

    def cache
      @cache ||= if config.cache[:enabled]
                   config.cache[:store]
                 else
                   ActiveSupport::Cache::NullStore.new
                 end
    end

    def importmap
      Importmap::Map.new.draw do
        pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
        pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
        pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
        pin "application", to: "ahoy_captain/application.js", preload: true
        pin "chartkick", to: "chartkick.js"
        pin "Chart.bundle", to: "Chart.bundle.js"
        pin "chartjs-plugin-datalabels", to: "https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2", preload: true
        pin "classnames", to: "https://cdnjs.cloudflare.com/ajax/libs/classnames/2.3.2/index.min.js", preload: true
        pin "chartjs-chart-geo", to: "https://unpkg.com/chartjs-chart-geo@4", preload: true
        pin_all_from AhoyCaptain::Engine.root.join("app/assets/javascript/ahoy_captain/controllers"), under: "controllers", to: "ahoy_captain/controllers"
        pin_all_from AhoyCaptain::Engine.root.join("app/assets/javascript/ahoy_captain/helpers"), under: "helpers", to: "ahoy_captain/helpers"
      end
    end

    def config
      self.configuration ||= Configuration.new
    end

    def configure
      yield config
    end

    def event
      @event ||= config.models[:event].constantize
    end

    def visit
      @visit ||= config.models[:visit].constantize
    end

    def none
      @none ||= ::OpenStruct.new(text: "(none)", value: "!none!")
    end
  end
end
