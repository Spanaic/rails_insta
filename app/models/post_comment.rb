class PostComment < ApplicationRecord
    belongs_to :user, optional: true
    belongs_to :post_image, optional: true
    # optional: trueとは、　post_imageモデルのカラムのnilを許容する。という意味
    # belongs_toで関連付けされたモデルは'allow_nil:false'とデフォルトで設定されている
    # nilを埋めることができない場合に有効。
    # optional: trueを加えることで,validatesのPost image must existが消えた

    # ポストコメントにidを付与(resources)してdeleteしていたが、中間テーブルのため、idを付与しなくても探し出すことが可能.
    # viewに渡された.eachされているブロック変数とparams[:id or 〇〇_id]を指定するだけで特定可能なため。

    validates :comment, presence: true

    # I wrote this for pull request
end
