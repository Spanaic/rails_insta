module PostImagesHelper
    def render_with_hashtags(caption)
        caption.gsub(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/){|word| link_to word, "/post/hashtag/#{word.delete("#")}"}.html_safe
        # 全角か半角かを条件分岐できればURLを作成することができるかもしれない。　＝＞　作成できた。
        # .gsubメソッドは正規表現にマッチした部分の値を、すべて指定の文字列に置き換える。
        # .gsub(正規表現){|指定の文字列|　link_to 指定の文字列, "指定のURL/#{指定の文字列.delete("#"消したい")"}.
        # .html_safeを使用するとエスケープ処理されなくなる。
        # エスケープ処理とは、特殊な文字列を勝手に変換してくれる処理のこと。
        # .html_safeをすることで、特殊な文字列でも変換されなくなる。
    end
end
