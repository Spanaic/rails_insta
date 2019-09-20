class PostComment < ApplicationRecord
    belongs_to :user, optional: true
    belongs_to :post_image, optional: true
    # optional: true
    # optional: trueを加えることで,validatesのPost image must existが消えた

    validates :comment, presence: true
end
