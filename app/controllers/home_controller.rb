class HomeController < ApplicationController
  def fetch_data
    respond_to do |format|
      format.csv { send_data candidates_fetcher, filename: "candidates_data.csv" }
    end
  end

  private

  def candidates_fetcher
    CandidatesFetcher.perform
  end
end
