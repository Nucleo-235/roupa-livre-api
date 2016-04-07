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
#

class KindHeartedUser < User
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable,
          :confirmable, :omniauthable
  
  include DeviseTokenAuth::Concerns::User

  before_save :skip_confirmation!
  
  mount_uploader :image, UserImageUploader
  validates :image, allow_blank: true, file_size: { maximum: 3.megabytes.to_i,  message: "O arquivo enviado é muito grande. Tamanho máximo 3 MB."}

  # def twitter
  #   identities.where( :provider => "twitter" ).first
  # end

  # def twitter_client
  #   @twitter_client ||= Twitter.client( access_token: twitter.accesstoken )
  # end

  def facebook
    identities.where( :provider => "facebook" ).first
  end

  def facebook_client
    @facebook_client ||= Facebook.client( access_token: facebook.accesstoken )
  end

  # def instagram
  #   identities.where( :provider => "instagram" ).first
  # end

  # def instagram_client
  #   @instagram_client ||= Instagram.client( access_token: instagram.accesstoken )
  # end

  # def google_oauth2
  #   identities.where( :provider => "google_oauth2" ).first
  # end

  # def google_oauth2_client
  #   if !@google_oauth2_client
  #     @google_oauth2_client = Google::APIClient.new(:application_name => 'HappySeed App', :application_version => "1.0.0" )
  #     @google_oauth2_client.authorization.update_token!({:access_token => google_oauth2.accesstoken, :refresh_token => google_oauth2.refreshtoken})
  #   end
  #   @google_oauth2_client
  # end

  def register(params, user_type)
    params = params.merge(type: user_type, uid: params[:uid].present? ? params[:uid] : nil)
    self.update_attributes(params)
  end
end
