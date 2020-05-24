# frozen_string_literal: true
require 'open-uri'
class Url < ApplicationRecord
  validates :short_url, :presence => true
  validates :original_url, :presence => true

  has_many :clicks
  # scope :latest, -> {}

  def generate_short_url
    unique = false
    while unique != true
      url = ([*('a'..'z'),*('A'..'Z'), *('0'..'9')]).sample(5).join()
      short_urls = Url.pluck(:short_url)
      unique = true if !short_urls.include?(url)
    end
    return url
  end

  def validate_url(original_url)
    URI.parse(original_url).respond_to?(:open)
  end
end

#
# Max length 5 character e.g. NELNT
# Allows Uppercase and Lowercase characters
# Allows Number
# Any non-word character is not allowed e.g whitespaces, tab,% ,$.* etc
# URL must be unique
# Original URL format should be validated
# shot_url attribute should be stored only the generated code
