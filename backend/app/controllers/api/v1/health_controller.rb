module Api
  module V1
    class HealthController < ApplicationController
      def index
        render json: { status: "ok" }

        # test
      end
    end
  end
end
