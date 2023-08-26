# == Schema Information
#
# Table name: shared_lists
#
#  id            :bigint           not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  friendship_id :bigint           not null
#  list_id       :bigint           not null
#
# Indexes
#
#  index_shared_lists_on_friendship_id              (friendship_id)
#  index_shared_lists_on_list_id                    (list_id)
#  index_shared_lists_on_list_id_and_friendship_id  (list_id,friendship_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (friendship_id => friendships.id)
#  fk_rails_...  (list_id => lists.id)
#
class SharedList < ApplicationRecord
  belongs_to :friendship
end

