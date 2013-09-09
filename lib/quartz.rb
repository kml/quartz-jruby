require 'java'

unless $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))
  $:.unshift(File.dirname(__FILE__))
end

require 'rubygems'
require 'singleton'

# require jars
require 'quartz/jars/slf4j-log4j12-1.6.1'
require 'quartz/jars/slf4j-api-1.6.1'
require 'quartz/jars/log4j-1.2.14'
require 'quartz/jars/quartz-2.0.1'

require 'quartz/cron_job'
require 'quartz/job_blocks_container'
require 'quartz/scheduler'
