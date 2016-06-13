class TransferJob < ActiveJob::Base
  queue_as :default

  def perform(action, import_type, import_batch = nil)
    action_method = TransferJob.actions action
    raise "Invalid remote action #{action}!" unless action_method

    objects = CollectionSpaceObject.includes(:data_object)
      .where(type: import_type)
      .entries.select { |object|
      (import_batch.nil? or object.data_object.import_batch == import_batch) ? object : nil;
    }
    objects.each do |object|
      service = RemoteActionService.new(object)
      service.send action_method
    end
  end

  def self.actions(action)
    {
      "delete" => :remote_delete,
      "remote_delete" => :remote_delete,
      "transfer" => :remote_transfer,
      "remote_transfer" => :remote_transfer,
    }[action]
  end
end