# == Schema Information
#
# Table name: chat_apparels
#
#  id         :integer          not null, primary key
#  chat_id    :integer
#  apparel_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  deleted_at :datetime
#

class ChatApparel < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :chat
  belongs_to :apparel
end
