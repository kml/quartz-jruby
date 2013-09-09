require File.dirname(__FILE__) + '/test_helper.rb'

# Uncomment for debug mode
# org.apache.log4j.BasicConfigurator.configure

class TestScheduler < Test::Unit::TestCase
  class Scheduler
    class << self
      attr_accessor :dis_concurrent, :no_dis_concurrent, :with_interrupt
    end

    include Quartz::Scheduler

    # run every one second, but should be invoked each 4 seconds only (sleep statement and disallow_concurrent option)
    schedule(:dis_concurrent, cron: "0/1 * * * * ?", disallow_concurrent: true) do
      Scheduler.dis_concurrent = Scheduler.dis_concurrent.to_i + 1
      sleep 4
    end
    # run every one second, even if the task takes longer. fired immediately after scheduler.run
    # fired four times - once at the scheduler.run and then three times during sleep(3) in thest method
    schedule(:no_dis_concurrent, every: 1) do
      Scheduler.no_dis_concurrent = Scheduler.no_dis_concurrent.to_i + 1
      sleep 2
    end
    # it should run 10 times if not interrupted
    schedule(:with_interrupt, every: 180) do |job|
      (1..10).each do |i|
        # job.interrupted? returns false only three times
        break if job.interrupted?
        Scheduler.with_interrupt = Scheduler.with_interrupt.to_i + 1
        sleep 1
      end
    end

    # Just an example how to define other cron job tasks
    # schedule(:days_3, cron: "0 37 1 ? * SAT#3") { puts 'third saturday in the month' }
  end

  def test_should_run_scheduler_and_jobs
    scheduler = Scheduler.instance
    scheduler.run
    sleep 3
    scheduler.stop

    assert_equal 1, Scheduler.dis_concurrent
    assert_equal 4, Scheduler.no_dis_concurrent
    assert_equal 3, Scheduler.with_interrupt
  end
end
