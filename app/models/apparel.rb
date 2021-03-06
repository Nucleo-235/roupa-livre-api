# == Schema Information
#
# Table name: apparels
#
#  id          :integer          not null, primary key
#  user_id     :integer          not null
#  title       :string           not null
#  description :text
#  size_info   :string
#  gender      :string
#  age_info    :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  deleted_at  :datetime
#

require 'securerandom'

class Apparel < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :user

  acts_as_mappable :through => :user

  has_many :apparel_images, -> { order('sort_order ASC') }, dependent: :destroy
  accepts_nested_attributes_for :apparel_images, :allow_destroy => true

  has_many :apparel_tags, dependent: :destroy
  accepts_nested_attributes_for :apparel_tags, :allow_destroy => true

  has_many :apparel_ratings, dependent: :destroy
  has_many :apparel_reports, dependent: :destroy
  has_many :chat_apparels, dependent: :destroy

  validate :check_same_name
  validates_presence_of :title, :user

  def main_image
    self.apparel_images.first
  end

  def similars
    self.user.apparels.where(title: self.title, description: self.description).where.not(id: self.id)
  end

  def report(user, reason)
    self.apparel_reports.create(user: user, number: SecureRandom.hex(16), reason: reason)
  end

  protected
    def check_same_name
      if self.similars.count > 0
        errors.add(:title, :duplicate)
        return false
      end
    end
end
