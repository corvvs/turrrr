# memo

## 仕様について

理論的には端がある形でも問題ないそう：（https://ja.wikipedia.org/wiki/%E3%83%81%E3%83%A5%E3%83%BC%E3%83%AA%E3%83%B3%E3%82%B0%E3%83%9E%E3%82%B7%E3%83%B3#cite_note-4 ）  
また、課題文にも左端を固定しているものを例としているように見えるので、左端は固定で良いと考えられる。

課題pdfのp.8の例を見れば、何を作ればいいかだいたいわかる

## OCamlセットアップ

参考サイト

https://qiita.com/bootsy/items/40aaab56b65777950877  
https://qiita.com/takl/items/3ff080ada902f6d4b490  
https://scrapbox.io/nekketsuuu/Windows%E4%B8%8A%E3%81%ABOCaml%E3%81%AE%E9%96%8B%E7%99%BA%E7%92%B0%E5%A2%83%E3%82%92%E4%BD%9C%E3%82%8B_2020

環境は、windowsのwsl

### install

```
sudo apt update
sudo apt install opam
```

```
opam init
```

Do you want opam to modify ~/.profile? [N/y/f]  
(default is 'no', use 'f' to choose a different file)

にはenter

A hook can be added to opam's init scripts to ensure that the shell remains in sync with the opam environment when they are loaded. Set that up? [y/N]

にはN

```
eval $(opam env)
```

opam initからはvscode再起動の度に後半は毎回行う？（未確認）

### ocamlfindのinstall

※以下の方法はだめ

https://command-not-found.com/ocamlfind

```
sudo apt-get install ocaml-findlib
```

### yojson

```
opam install yojson
```

動かなかったので、もう一度

```
opam init
eval $(opam env)
```

をした、opam init の2回目の質問には誤ってyにした

### 改めてocamlfindのinstall

yojsonを入れた後、ocamlfindをopamで入れなおした

```
opam install ocamlfind
```

### ワカモレ環境構築

brewのinstall

https://scrapbox.io/42tokyo-42cursus/Install_Valgrind_to_Guacamole_feat._unlimish

```
curl -fsSL https://rawgit.com/kube/42homebrew/master/install.sh | zsh && source ~/.zshrc
```

brewでopamのinstall

https://zenn.dev/hoddy3190/articles/4b7347ecd7ba59

```
brew install opam
```

失敗

```
brew upgrade wget
```

wgetがないといわれる

```
brew install wget
```

なんかの依存パッケージがダウンロードできなかった

```
brew install opam
```

なぜかいけてしまった。  
多分上の色々で失敗している仮定で必要なものが入ったのかも（もしくは通信状況の問題か）

```
opam init
```

失敗

```
brew install wget
```

なぜかいけた

```
opam init
```

これで完了


## OCaml入門

とりあえず以下をやる

http://ocaml.jp/?OCaml%E5%85%A5%E9%96%80%281%29

## 今後の予定

- Ocamlの学習: 1週×2
- Makefile: 3日
- json to 構造体（？）: 1～5日
- 遷移: 5日
- チューリングマシン×5: 5日
- ボーナス: 5日

## OCaml参考サイト

- compileについて：https://ryskosn.hatenadiary.com/entry/2017/09/18/192919
- サンプルプログラム集：http://simplesandsamples.com/println.ml.html
- Makefile参考：https://www.fos.kuis.kyoto-u.ac.jp/~igarashi/OCaml/

## 実装について

pdfにある以下のような部分

```
(scanright, .) -> (scanright, ., RIGHT)
```
がなんとなく関数っぽい。
そして、この関数をつなげて出力するようにすれば関数型言語っぽくなるのではと思った。

また、このつなげるパターンとかでもしかして時間計算量が計算できる……？

## チューリングマシンについて

- 今回のチューリングマシンは決定的チューリングマシン
> 遷移関数において、現在の状態 q と着目位置にある記号 a の、ある組 (q, a) に対し、値（すなわちその時にすべき動作）が、高々一つならば、そのチューリングマシンは「決定的」（deterministic）である（https://ja.wikipedia.org/wiki/%E3%83%81%E3%83%A5%E3%83%BC%E3%83%AA%E3%83%B3%E3%82%B0%E3%83%9E%E3%82%B7%E3%83%B3#%E6%B1%BA%E5%AE%9A%E7%9A%84%E3%81%A8%E9%9D%9E%E6%B1%BA%E5%AE%9A%E7%9A%84 ）

- 現在の状態Sから次の状態へN個の分岐（選択肢）があり、分岐の深さをHとする。決定性チューリングマシンの場合、計算量はN^H？（https://motojapan.hateblo.jp/entry/2017/11/15/082738#%E6%B1%BA%E5%AE%9A%E6%80%A7%E9%9D%9E%E6%B1%BA%E5%AE%9A%E6%80%A7%E3%83%81%E3%83%A5%E3%83%BC%E3%83%AA%E3%83%B3%E3%82%B0%E3%83%9E%E3%82%B7%E3%83%B3%E3%81%AE%E9%81%95%E3%81%84 ）

- チューリングマシンの説明。わかりやすかった：https://zenn.dev/airev/articles/airev-quantum-03

- 時間計算量と空間計算量：https://www.marulabo.net/docs/turing-complex/#%E3%80%8C%E6%99%82%E9%96%93%E8%A8%88%E7%AE%97%E9%87%8F%E3%80%8D%E3%81%A8%E3%80%8C%E7%A9%BA%E9%96%93%E8%A8%88%E7%AE%97%E9%87%8F%E3%80%8Dblog

- プログラムの停止性判定。（一般的な話？）
> プログラムの停止性を有限時間で判定するプログラムを作ることができない (https://www.eidos.ic.i.u-tokyo.ac.jp/~alumni/liquid/notes/computation.pdf の11プログラムの停止性判定 )

- 上記のpdfの16計算量の理論が、計算量にかかわる話
  - クラスP：決定性 TM において問題サイズの多項式時間で解ける問題

## 時間計算量の計算方法について

「このプロジェクトのボーナスは、あなたのプログラムが実行されたアルゴリズムの時間的複雑さを計算できるようにするために……」と書いてあるので、テープも用いて時間計算量を測るような気がする

その場合、今のところ以下の３つの方法が考えられる
1. 実際にたどった動きから計算する
2. jsonファイルからたどる可能性のあるパターン考慮して計算する
3. 比較対象となるプログラムを動かして、それとの時間比較で計算する

また、2つ目の方法の場合、以下の2つの指標が考えられる
1. 平均の時間計算量
2. 最大の時間計算量

例えば、最大の時間計算量で考えると、クイックソートはバブルソートと同じ計算量になってしまうため、直観に反する  
平均の計算量の場合、何を平均とするのかが難しい

また、3つ目の方法については、pcのスペックから時間計算ができる場合は実際に比較対象となるプログラムを動かさなくてもよい

## マシンのブロックの候補

- 無限ループ
  - 同じテープの状態で、同じstatusで、同じ位置になった場合にエラーにする？
- 左側に突き抜ける
- 右側に際限なくすすむ
  - 単純に右側に進み続ける
  - 動きを変えながら右側に進み続ける
- 対応するトランジションがない

## readエラーのパターン

- name, alphabet, blank, states, initial, finals, transitionsのいずれかがない
- あまりにも長いname（とりあえず100文字以内とする）
- nameがリスト
- alphabetがprintableでエスケープ文字ではないascii以外のパターン（printableなasciiだけ対応すればいいと思う）
  - 改行
  - ひらがな
  - \
- alphabetがかぶってる（これを許容する場合、リストの数を気にする必要がある）
- alphabetがリストではない
- alphabetの一つが1文字ではない
- alphabetが空
- blankがリスト
- blankがalphabetの一部ではない
- statusがリストではない
- statusが空
- あまりにも長いstatus（とりあえず100文字以内とする）
- あまりにも多いstatus（とりあえず2000個とする）（テスト未作成）
- statusの中身がかぶっている
- statusがprintableなascii以外のパターン（printableなasciiだけ対応すればいいと思う）
- initialがリスト
- initialがstatusの一部ではない
- finalsがリストではない
- finalsが空
- finalsがstatusの部分集合ではない
- finalsの中身がかぶっている
- transitionsの対称の状態がstatusにない
- transitionsのreadがalphabetにない
- transitionsのto_stateがstatusにない
- transitionsのwriteがalphabetにない
- transitionsのactionがLEFTかRIGHT以外
- transitionsのread, to_state, write, actionのいずれかがない
- transitionsの中身がかぶっている
- テープにblankが混じっている
- 長すぎるテープ（とりあえず100文字以内とする）

## 特殊だけどOKパターン

- transitionsがない


## 改めてやること

- エラーチェック
  - マシンのブロック
  - 入力チェック
    - json
    - テープ
- ５つのjsonファイルの作成
- Makefileの作成
  - （何もない環境でもmakeできることを確認する仮想環境の作製）
- ボーナス
- （テスターの作成）

## Makefile

### 参考になったサイト

- オプション: https://ocaml.jp/refman/ch08s02.html
- ocamlfindについて: https://ocaml-tutorial.org/ja/compiling_ocaml_projects
- makefile参考
  - https://ocaml.jp/archive/ocaml-manual-3.06-ja/manual027.html
  - https://www.fos.kuis.kyoto-u.ac.jp/~igarashi/OCaml/
- 各生成ファイルの説明: https://ocaml.jp/?Chapter%208%20%E3%83%90%E3%83%83%E3%83%81%E3%82%B3%E3%83%B3%E3%83%91%E3%82%A4%E3%83%A9%20%28ocamlc%29
- dependについて: http://exlight.net/devel/make/depend.html

## 5つめのマシンについて

- 1, ., +, =のみをアルファベットに
- r, lでRIGHT, LEFT,
- statusはA,B,Hの3つ
- blankは指定不可（.に）
- finalsも指定不可（Hに）
- これでも、2status * 4read * 3to_state * 4write * 2action = 192通りの状態がある
- 指定の仕方
  - [>A1A1R>A+A1R>A=B.L>B1H.R]111+11=

## 計算時間について

### unary_sub

graphvizで作製した画像を確認すると
- 最初のscanrightで、「.」「1」「-」のO(n)のループ
- suboneで「1」のO(n)のループ
- skipで「.」のO(n)のループ
- suboneとskipを含むループがある

……全部O(n)だが、suboneとskipは大きなループの中にある。  
動くを見るとO(n^2)っぽいが、それを遷移から読み取るのは難しい

### オーダー数の計算

unary_subを見ていると、遷移から調べるのは難しそう。  
やはり、ステップ数を単純に数えて、そこからオーダー数を考えるのがいいかもしれない。

課題pdfより、オーダーのリストは以下
- 1
- log n
- n
- n log n
- n^2
- 2^n
- n!

テープの長さをnとして、実際のステップ数とこれらを比較する。

#### 例

unary_subの"111-11="について考える
- n = 7, step = 23
- O(1): 1
- O(log n): 1.9 (底はe)
- O(n): 7
- O(n log n): 14
- O(n^2): 49

一番近いのはO(n log n)となる

もう少し増やしてunary_subの"11111111-11111="について考える
- n = 15, step = 82
- O(1): 1
- O(log n): 2.7 (底はe)
- O(n): 15
- O(n log n): 40
- O(n^2): 225

一番近いのはO(n log n)となる

さらに増やす："11111111111111-1111111111="
- n = 26, step = 258
- O(1): 1
- O(log n): 3.2 (底はe)
- O(n): 26
- O(n log n): 83
- O(n^2): 676

一番近いのはO(n log n)となる

さらに増やす："11111111111111111111-111111111111111111="
- n = 40, step = 744
- O(1): 1
- O(log n): 3.7 (底はe)
- O(n): 40
- O(n log n): 148
- O(n^2): 1600

一番近いのはO(n^2)となる

## 時間計算量について改めて調べる

- ここに書いてある参考書を読めばもしかしたら：https://qiita.com/drken/items/872ebc3a2b5caaa4a0d0
- 結構詳しく書いてあるが時間計算量の求め方についてはのっていない：https://www.kurims.kyoto-u.ac.jp/~kawamura/keisanryo/enshu.pdf
- チューリングマシンの、palindromeの時間計算量を計算していた。少し漠然とヒントになった気がする：http://edu.net.c.dendai.ac.jp/algorithm/2015/3/index.xhtml
- チューリングマシンの遷移図について。これにならって遷移図を書き直す：http://web.sfc.keio.ac.jp/~hagino/mi17/05.pdf
- 非決定性TMの話になってしまった：http://www.akita-pu.ac.jp/system/elect/ins/kusakari/japanese/teaching/InfoMath/2007/note/5.pdf
- かなり色々詳しく載っている：https://www.hirasa.mgmt.waseda.ac.jp/lab/imc.pdf
  - アルゴリズムにはその終了性が条件として入っている。そのため無限ループするような入力は、そもそもその要件を満たしていないのだからしょうがない、としてもいいかもしれない
  - 一般にテープ全体をnとするのではなく、一部の対象を（ソートだったらそのソートする要素の個数とか）nとすることが多いらしい
