# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  provider               :string           default("email"), not null
#  uid                    :string           not null
#  type                   :string           not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  name                   :string
#  email                  :string
#  nickname               :string
#  social_image           :string
#  image                  :string
#  phone                  :string
#  tokens                 :json
#  created_at             :datetime
#  updated_at             :datetime
#  lat                    :float
#  lng                    :float
#  agreed                 :boolean          default(FALSE), not null
#

class UsersController < ApplicationController
  before_action :authenticate_user!

  def register_device
    device = Device.find_or_create_by(user: current_user, 
      provider: update_device_params[:provider], 
      uid: update_device_params[:registration_id],
      device_uid: update_device_params[:device_uid])

    if device
      Device.where(user: current_user, 
        provider: update_device_params[:provider], 
        device_uid: update_device_params[:device_uid]).
        where.not(uid: update_device_params[:registration_id]).destroy_all
    end

    render json: device
  end

  def unregister_device
    Device.where(user: current_user, 
        provider: update_device_params[:provider], 
        device_uid: update_device_params[:device_uid]).destroy_all
    
    head :no_content
  end

  def update_image
    current_user.update(update_image_params)
    render json: current_user
  end

  def agreed_to_terms
    current_user.agreed = true
    current_user.agreed_at = Time.new
    
    if current_user.save
      render json: current_user
    else
      render json: current_user.errors, status: :unprocessable_entity
    end
  end

  protected

    def update_image_params
      params.permit(:image, :image_cache)
    end

    def update_device_params
      params.permit(:registration_id, :provider, :device_uid)
    end
end
