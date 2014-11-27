module Lipstick
  module Api
    class CampaignFindActiveResponse < Response
      int_csv_field :campaign_id
      csv_field :campaign_name
      def initialize(fields)
        fields[:response_code] = fields.delete(:response)
        super fields
      end
    end
  end
end
