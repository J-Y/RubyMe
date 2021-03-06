# encoding: utf-8
# require "digest/md5"
# require 'carrierwave/processing/mini_magick'

class UserAvatarUploader < CommonUploader

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  # storage :qiniu
  # self.qiniu_protocal = 'http'
  # self.qiniu_can_overwrite = true
  # self.qiniu_bucket = "avatars"
  # self.qiniu_bucket_domain = "avatars.files.example.com"
  # self.qiniu_protocal = 'http'

  def url(param={})
    "http://#{Settings.cdn.bucket_domain}/#{self.path}" unless self.blank?
  end


  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "#{Settings.cdn.dir_prefix}/users/#{model.id}"
  end

  def filename
    if original_filename.present?
      file_prefix = model.avatar.file.path.split('.').last.downcase
      "#{secure_token}.#{file_prefix}"
    end
  end

  def default_url
    # For Rails 3.1+ asset pipeline compatibility:
    ActionController::Base.helpers.asset_path("shared/user_avatar/" + [version_name, "default.jpg"].compact.join('_')).sub('/assets/', '')
  end

  process :resize_to_fill => [460, 460]


  # Create different versions of your uploaded files:
  version :thumb do
    # Process files as they are uploaded:
    # process :quality => 80
    process :resize_to_fit => [96, 96]
  end

  version :content do
    # Process files as they are uploaded:
    # process :quality => 80
    process :resize_to_fit => [800, 800]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg png)
  end

end
