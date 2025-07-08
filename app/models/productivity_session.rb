class ProductivitySession < ApplicationRecord
  belongs_to :user

  def calculate_duration
    return unless end_time && start_time
    self.duration = (end_time - start_time).to_i # in seconds
  end
end
