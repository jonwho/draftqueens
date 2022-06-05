# frozen_string_literal: true

require "faraday"
require "faraday/net_http"

module Draftqueens
  class ClientError < StandardError; end

  BASE_URL = "https://www.draftkings.com"
  API_BASE_URL = "https://api.draftkings.com"

  class Client
    def initialize(base_url: BASE_URL, api_base_url: API_BASE_URL)
      @client = Faraday.new
      @base_url = base_url
      @api_base_url = api_base_url
    end

    def draft_group_details(id)
      res = client.get(draft_group_url(id))
      JSON.parse(res.body)
    rescue StandardError => e
      raise ClientError, e
    end

    def countries
      res = client.get(countries_url)
      JSON.parse(res.body)
    rescue StandardError => e
      raise ClientError, e
    end

    def regions(code)
      res = client.get(regions_url(code))
      JSON.parse(res.body)
    rescue StandardError => e
      raise ClientError, e
    end

    def contests(sport)
      params = { "sport" => sport }
      res = client.get(contests_url, params)
      JSON.parse(res.body)
    rescue StandardError => e
      raise ClientError, e
    end

    def available_players(id)
      params = { "draftGroupId" => id }
      res = client.get(available_players_url, params)
      JSON.parse(res.body)
    rescue StandardError => e
      raise ClientError, e
    end

    def draftables(id)
      res = client.get(draftables_url(id))
      JSON.parse(res.body)
    rescue StandardError => e
      raise ClientError, e
    end

    def game_type_rules(id)
      res = client.get(game_type_rules_url(id))
      JSON.parse(res.body)
    rescue StandardError => e
      raise ClientError, e
    end

    private

    attr_reader :client, :base_url, :api_base_url

    def draft_group_url(id)
      "#{api_base_url}/draftgroups/v1/#{id}"
    end

    def countries_url
      "#{api_base_url}/addresses/v1/countries"
    end

    def regions_url(code)
      "#{api_base_url}/addresses/v1/countries/#{code}/regions"
    end

    def contests_url
      "#{base_url}/lobby/getcontests"
    end

    def available_players_url
      "#{base_url}/lineup/getavailableplayers"
    end

    def draftables_url(id)
      "#{api_base_url}/draftgroups/v1/draftgroups/#{id}/draftables"
    end

    def game_type_rules_url(id)
      "#{api_base_url}/lineups/v1/gametypes/#{id}/rules"
    end
  end
end
