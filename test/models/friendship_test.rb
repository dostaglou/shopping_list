# == Schema Information
#
# Table name: friendships
#
#  id            :bigint           not null, primary key
#  invited_email :string           not null
#  status        :integer          default("pending"), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  invited_id    :bigint
#  inviter_id    :bigint           not null
#
# Indexes
#
#  index_friendships_on_invited_id  (invited_id)
#  index_friendships_on_inviter_id  (inviter_id)
#
# Foreign Keys
#
#  fk_rails_...  (invited_id => users.id)
#  fk_rails_...  (inviter_id => users.id)
#
require "test_helper"

class FriendshipTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
