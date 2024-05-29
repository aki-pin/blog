# frozen_string_literal: true
require 'rubygems'
require 'bundler/setup'

require 'cloudinary'
require 'cloudinary/search'
require 'cloudinary/uploader'
require 'cloudinary/utils'

require_relative './image_uploader'

require 'uri'
class OGPUploader
  def self.call(title, path, author)
    new.call(title, path, author)
  end

  def call(title, path, author)
    original_ogp_url = Cloudinary::Search.expression("public_id=ogp_base").execute["resources"][0]["url"]

    ImageUploader.call(original_ogp_url, path, "ogp", options(title, author))
  end

  private

  def options(title, author)
    [
      {:width=>1200, :height=>630, :crop=>"scale"},
      {:overlay=>{:font_family=>"notosansjp.ttf", :font_size=>60, :font_weight=>"bold", :text_align=>"left", :text=> title },
      :color=>"#FFFFFF", :width=>1000, :height=>300, :quality=>"auto", :crop=>"fit"},
      {:flags=>"layer_apply", :gravity=>"north_west", :x=>100, :y=>150},
      {:color=>"#FFFFFF", :overlay=>{:font_family=>"notosansjp.ttf", :font_weight=>"bold", :font_size=>40, :text_align=>"left", :text=> author }},
      {:flags=>"layer_apply", :gravity=>"south_west", :x=>100, :y=>75}
    ]
  end
end
