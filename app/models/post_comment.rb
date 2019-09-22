class PostComment < ApplicationRecord
    belongs_to :user, optional: true
    belongs_to :post_image, optional: true
    # optional: true
    # optional: trueを加えることで,validatesのPost image must existが消えた

    # ポストコメントにidを付与(resources)してdeleteしていたが、中間テーブルのため、idを付与しなくても探し出すことが可能.
    # viewに渡された.eachされているブロック変数とparams[:id or 〇〇_id]を指定するだけで特定可能なため。

    validates :comment, presence: true
end
