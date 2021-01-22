class GroupEventsController < ApplicationController
	protect_from_forgery
	#showing only published events. Scope defined in model. Using gem kaminari for pagination.
	def index
		@group_events = GroupEvent.published.page(params[:page]).per(10).order(created_at: "ASC") 
		render json: {
			code: 200,
			success: true,
			message: "Published GroupEvents",
			data: @group_events
			}
	end

	def show_event
		if !params[:event_id].blank?
			@event = GroupEvent.find(params[:event_id])
			render json: {
				code: 200,
				success: true,
				message: "GroupEvent",
				data: get_group_event_object(@event)
			}
		else
	        render json: {
		        code: 400,
		        success: false,
		        message: "event_id is required.",
		        data: nil
		      }	
		end	
	end

	def create
		@event = GroupEvent.new
		@event.name = params[:name]
		@event.description = params[:description]
		@event.location = params[:location]
		@event.start_date = params[:start_date]
		@event.end_date = params[:end_date]
		@event.duration = params[:duration]

		# if one of start_date, end_date or duration is missing
		if params[:start_date].blank?
			@event.start_date = params[:end_date].to_date - params[:duration].to_i
		elsif params[:end_date].blank?
			@event.end_date = params[:start_date].to_date + params[:duration].to_i
		else params[:duration].blank?
			@event.duration = params[:end_date].to_date - params[:start_date].to_date				
		end		

		if @event.save
			render json: {
				code: 200,
				success: true,
				message: "GroupEvent successfully created",
				data: get_group_event_object(@event)
			}
		else
			render json: {
				code: 400,
				success: false,
				message: @event.errors.full_messages,
				data: nil
			}
		end
	end

	def update
		@event = GroupEvent.find(params[:id])
		@event.name = params[:name]
		@event.description = params[:description]
		@event.location = params[:location]
		@event.start_date = params[:start_date]
		@event.end_date = params[:end_date]
		@event.duration = params[:duration]

		# if one of start_date, end_date or duration is missing
		if params[:start_date].blank?
			@event.start_date = params[:end_date].to_date - params[:duration].to_i
		elsif params[:end_date].blank?
			@event.end_date = params[:start_date].to_date + params[:duration].to_i
		else params[:duration].blank?
			@event.duration = params[:end_date].to_date - params[:start_date].to_date				
		end		

		if @event.save
			render json: {
				code: 200,
				success: true,
				message: "GroupEvent successfully update",
				data: get_group_event_object(@event)
			}
		else
			render json: {
				code: 400,
				success: false,
				message: @event.errors.full_messages,
				data: nil
			}
		end
	end

	def delete_event
		if !params[:event_id].blank?
			@event = GroupEvent.find(params[:event_id])
			if @event.is_deleted == true
				render json: {
					code: 200,
					success: true,
					message: "GroupEvent already deleted",
					data: get_group_event_object(@event)
				}
			else
				@event.update(is_deleted: true)
				render json: {
					code: 200,
					success: true,
					message: "GroupEvent deleted successfully",
					data: get_group_event_object(@event)
				}
			end
		else
	      render json: {
		        code: 400,
		        success: false,
		        message: "event_id is required.",
		        data: nil
		      }	
		end	
	end

	def publish_event
		if !params[:event_id].blank?
			@event = GroupEvent.find(params[:event_id])
			if !@event.name.blank? && !@event.description.blank? && !@event.location.blank?
				if @event.status == 0
					@event.update(status: 1) #status 1 represents published and 0 represents draft
					render json: {
						code: 200,
						success: true,
						message: "GroupEvent published successfully",
						data: get_group_event_object(@event)
					}
				else
					render json: {
						code: 200,
						success: true,
						message: "GroupEvent already published",
						data: get_group_event_object(@event)
					}
				end
			else
				render json: {
					code: 400,
					success: false,
					message: "Event can't be published with empty/nil fields. Please fill out all the fields",
					data: nil
				}
			end
		else
	      render json: {
		        code: 400,
		        success: false,
		        message: "event_id is required.",
		        data: nil
		      }	
		end	
	end


	private

	def get_group_event_object(event)
		object = {
		"name" => event.name,
		"description" => event.description,
		"location" => event.location,
		"start_date" => event.start_date,
		"end_date" => event.end_date,
		"duration" => event.duration,
		"status" => event.status,
		"is_deleted" => event.is_deleted
		}
	end
end