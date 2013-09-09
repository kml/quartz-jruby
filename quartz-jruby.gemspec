# -*- encoding: utf-8 -*-

$:.push File.expand_path("../lib", __FILE__)
require 'quartz/version'

Gem::Specification.new do |s|
  s.name = %q{quartz-jruby}
  s.version = Quartz::VERSION

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Vagmi Mudumbai", 'Michal Ochman']
  s.description = %q{From {Quartz Scheduler's website}[http://www.quartz-scheduler.org/]

Quartz is a full-featured, open source job scheduling service that can be integrated with, or used along side virtually any Java EE or Java SE application - from the smallest stand-alone application to the largest e-commerce system. Quartz can be used to create simple or complex schedules for executing tens, hundreds, or even tens-of-thousands of jobs; jobs whose tasks are defined as standard Java components that may executed virtually anything you may program them to do. The Quartz Scheduler includes many enterprise-class features, such as JTA transactions and clustering.

This gem makes these available in a ruby friendly syntax}
  s.email = ["vagmi@artha42.com", 'ocherek@gmail.com']
  s.extra_rdoc_files = ["History.txt"]
  s.files = ["History.txt", "LICENSE", "README.md", "lib/quartz.rb", "lib/quartz/cron_job.rb", "lib/quartz/scheduler.rb", "lib/quartz/job_blocks_container.rb", "lib/quartz/version.rb", "test/test_helper.rb", "test/test_quartz-jruby.rb"]
  s.homepage = %q{http://github.com/ocher/quartz-jruby}
  s.rdoc_options = ["--main", "quartz-jruby.rdoc"]
  s.require_paths = ["lib", "vendor"]
  s.rubyforge_project = %q{quartz-jruby}
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{From {Quartz Scheduler's website}[http://www.quartz-scheduler.org/]  Quartz is a full-featured, open source job scheduling service that can be integrated with, or used along side virtually any Java EE or Java SE application - from the smallest stand-alone application to the largest e-commerce system}
  s.test_files = ["test/test_helper.rb", "test/test_quartz-jruby.rb"]
end
