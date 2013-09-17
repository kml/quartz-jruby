# encoding: utf-8

require 'singleton'

java_import org.quartz.JobKey
java_import org.quartz.JobBuilder
java_import org.quartz.TriggerBuilder
java_import org.quartz.impl.StdSchedulerFactory
java_import org.quartz.SimpleScheduleBuilder
java_import org.quartz.CronScheduleBuilder
java_import org.quartz.TriggerKey

module Quartz
  module Scheduler
    def self.included(base)
      base.class_eval do
        include InstanceMethods
        extend ClassMethods
        include Singleton
      end
    end

    module ClassMethods
      def schedule(name, options, &block)
        instance.schedule(name, options, block)
      end
    end

    module InstanceMethods
      def schedule(name, options, block)
        register_job(name, options, block)

        job_runner_class = options[:disallow_concurrent] ? Quartz::CronJobSingle : Quartz::CronJob

        job_detail = JobBuilder.new_job(job_runner_class.java_class).tap do |builder|
          builder.with_identity(name.to_s, group)
          builder.with_description(options[:description]) if options[:description]
        end.build

        trigger_schedule = if options[:cron]
          CronScheduleBuilder.cron_schedule(options[:cron])
        else
          SimpleScheduleBuilder.
            simple_schedule.
            with_interval_in_seconds(options[:every].to_i).
            repeat_forever
        end

        trigger = TriggerBuilder.
          new_trigger.
          for_job(job_detail).
          with_identity("#{name}_trigger", group).
          with_schedule(trigger_schedule).
          build

        scheduler.schedule_job(job_detail, trigger)
     end

      def unschedule(name)
        scheduler.unschedule_job(trigger_key(name))
      end

      def delete(name)
        scheduler.delete_job(job_key(name))
      end

      def pause(name)
        scheduler.pause_job(job_key(name))
      end

      def resume(name)
        scheduler.resume_job(job_key(name))
      end

      def trigger_key(name)
        TriggerKey.triggerKey("#{name}_trigger", group)
      end

      def job_key(name)
        JobKey.jobKey(name, group)
      end

      def group
        self.class.to_s
      end

      def scheduler_factory
        @scheduler_factory ||= StdSchedulerFactory.new
      end

      def scheduler
        @scheduler ||= scheduler_factory.get_scheduler
      end

      def register_job(name, options, block)
        job_code_blocks.jobs[name.to_s] = block
      end

      def job_code_blocks
        JobBlocksContainer.instance
      end

      def run
        scheduler.start
      end

      def interrupt
        scheduler.standby # don't trigger new jobs
        scheduler.getCurrentlyExecutingJobs.each do |job_context|
          scheduler.interrupt(job_context.job_detail.key) # interrupt job
        end
      end

      def stop
        interrupt
        wait_for_jobs_to_complete = true
        scheduler.shutdown(wait_for_jobs_to_complete)
      end
    end
  end
end

