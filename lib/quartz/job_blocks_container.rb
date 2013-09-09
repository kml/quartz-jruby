require 'singleton'

module Quartz
  class JobBlocksContainer
    include Singleton

    attr_accessor :jobs
    def initialize
      @jobs ||= {}
    end
  end
end
