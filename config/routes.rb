Rails.application.routes.draw do
	post "/group-events" => 'group_events#create'
	put "/group-events/:id" => 'group_events#update'
	post "/group-events/publish-event" => 'group_events#publish_event'
	post "/group-events/delete-event" => 'group_events#delete_event'
	post "/group-events/show-event" => 'group_events#show_event'
	get "/group-events" => 'group_events#index'
end
