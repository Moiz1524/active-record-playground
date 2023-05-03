class DestroyUsersJob < ApplicationJob
  queue_as :default

  def perform(*args)
    User.last(1000).each do |user|
      user.destroy
    end
  end
end
