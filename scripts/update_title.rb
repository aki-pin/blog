# frozen_string_literal: true

require 'rubygems'
require 'bundler/setup'

require 'cloudinary'
require 'cloudinary/search'
require 'cloudinary/uploader'
require 'cloudinary/utils'

require 'uri'

require_relative '../lib/ogp_uploader.rb'
require_relative '../lib/ogp_setter.rb'


if Cloudinary.config.api_key.blank?
  require_relative '../config/cld_config.rb'
end

raise '引数が不足しています．' unless ARGV.length == 3

title_arg, path_arg, author_arg = ARGV

title_match = title_arg.match(/^title=(.+)$/)
path_match = path_arg.match(/^path=(.+)$/)
author_match = author_arg.match(/^author=(.+)$/)

raise '引数が不正です．' unless title_match && path_match && author_match

# 形式が正しい場合は値を抽出
title = title_match[1]
path = path_match[1]
author = author_match[1]

ogp_url = OGPUploader.call(title, path, author)

updated_lines = File.readlines("entries/#{path}/entry.md").map do |line|
  if line =~ /^Title:/
    line = "Title: #{title}"
  elsif line.match(/\!\[ogp\]\((.*?)\)/)
    image_relative_path = $1
    line.gsub(image_relative_path, ogp_url)
  else
    line
  end
end

File.open("entries/#{path}/entry.md", 'w') { |file| file.puts(updated_lines) }
