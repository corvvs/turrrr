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
