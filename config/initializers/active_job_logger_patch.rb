ActiveSupport.on_load :active_job do
  class ActiveJob::Logging::LogSubscriber
    private def args_info(job)
      if job.arguments.any?
        if job.class == BuyJob
          " #{job.class} arguments is masking"
        else
          ' with arguments: ' +
            job.arguments.map { |arg| arg.try(:to_global_id).try(:to_s) || arg.inspect }.join(', ')
        end
      else
        ''
      end
    end
  end
end