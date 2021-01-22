require 'rails_helper'
require "spec_helper"

#For rspec testing, I have use development db data. 
RSpec.describe GroupEventsController, type: :controller do
  describe "GroupEvent APIs" do

    it "should return all events" do
      get :index
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["success"]).to eq(true)
    end

    it "should return a specific event" do
      post :show_event, params: {event_id: GroupEvent.last.id}
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["success"]).to eq(true)
    end

    it "should create an Event" do
      post :create, params: {
      name: "Test Dashboard",
      description: "test description",
      location: "London",
      start_date: "2020-01-11",
      end_date: "2020-01-13",
      duration: 2,
      status: 0,
      is_deleted: false
      }
    expect(response).to have_http_status(200)
    expect(JSON.parse(response.body)["message"]).to eq("GroupEvent successfully created")
    expect(JSON.parse(response.body)["success"]).to eq(true)
    end

    it "should not create the Event if the start_date is after the end_date" do
      post :create, params: {
      name: "Test Dashboard",
      description: "test description",
      location: "London",
      start_date: "2020-01-18",
      end_date: "2020-01-13",
      duration: 2,
      status: 0,
      is_deleted: false
      }
    expect(response).to have_http_status(200)
    expect(JSON.parse(response.body)["success"]).to eq(false)
    expect(JSON.parse(response.body)["message"]).to eq(["Start date should be before end date"])
    end

    it "should create the Event if duration is missing and calculate the value is well" do
      post :create, params: {
      name: "Test Dashboard",
      description: "test description",
      location: "London",
      start_date: "2020-01-11",
      end_date: "2020-01-13",
      duration: nil,
      status: 0,
      is_deleted: false
      }
    expect(response).to have_http_status(200)
    expect(JSON.parse(response.body)["success"]).to eq(true)
    expect(JSON.parse(response.body)["message"]).to eq("GroupEvent successfully created")
    end

    it "should publish event" do
      post :publish_event, params: {event_id: GroupEvent.last.id}
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["success"]).to eq(true)
	  expect(JSON.parse(response.body)["message"]).to eq("GroupEvent published successfully")
    end

    it "should show message that event is already published if status is equal to 1" do
      post :publish_event, params: {event_id: GroupEvent.first.id}
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["success"]).to eq(true)
	  expect(JSON.parse(response.body)["message"]).to eq("GroupEvent already published")
    end

    it "should delete event" do
      post :delete_event, params: {event_id: GroupEvent.last.id}
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["success"]).to eq(true)
	  expect(JSON.parse(response.body)["message"]).to eq("GroupEvent deleted successfully")
    end

    it "should show message that event is already deleted if is_deleted is equal to true" do
      post :delete_event, params: {event_id: GroupEvent.first.id}
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body)["success"]).to eq(true)
	  expect(JSON.parse(response.body)["message"]).to eq("GroupEvent already deleted")
    end
  end
end