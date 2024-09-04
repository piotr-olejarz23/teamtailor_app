module Performable
  extend ActiveSupport::Concern

  def perform(...)
    new(...).perform
  end
end
