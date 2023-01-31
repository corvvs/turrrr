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

## compileについて

https://ryskosn.hatenadiary.com/entry/2017/09/18/192919
