require "rails_helper"

RSpec.describe "API V1 Health", type: :request do
  describe "GET /api/v1/health" do
    it "returns a successful response" do
      get "/api/v1/health"

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body).to eq("status" => "ok")
    end
  end
end
