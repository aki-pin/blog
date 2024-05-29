require 'rubygems'
require 'bundler/setup'

require 'cloudinary'
require 'cloudinary/search'
require 'cloudinary/uploader'
require 'cloudinary/utils'

require 'uri'
class ImageUploader
  # @param [String] image_path アップロードする画像のパス
  # @param [String] folder アップロード先のフォルダ名
  # @param [String] public_id アップロード先のファイル名
  # @param [Array] transformation Cloudinaryの画像変換オプション
  # @return [String] アップロードされた画像のURL

  def self.call(image_path, folder, public_id, transformation = [])
    new.call(image_path, folder, public_id, transformation)
  end

  def call(image_path, folder, public_id, transformation)
    options = {
      :folder => folder,
      :public_id => public_id,
      :transformation => transformation
    }
    upload = Cloudinary::Uploader.upload(image_path, **options)

    upload["url"]
  end
end
