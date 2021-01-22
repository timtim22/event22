class GroupEvent < ApplicationRecord
	validate :check_valid_data
	scope :published, -> { where("status = ?",  1)} #defined scope to catchup published events only

	private

	def check_valid_data
		if start_date.to_date > end_date.to_date
			errors.add(:start_date, "should be before end date")
		elsif duration > end_date.to_date - start_date.to_date #we can also validate duration to less than end_date - start_date if duration is supposed to be equal to event length
			errors.add(:duration, "- wrong duration inserted.") 
		end 
	end
end
