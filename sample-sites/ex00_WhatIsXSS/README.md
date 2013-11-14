# XSSの初歩的な例と実害

を説明するデモです．

## 状況

XSS (__クロス__ サイト スクリプティング) の性質上，localhostの他にも別サイトが必要でした．

<dl>
  <dt>http://当日教える.com</dt>
  <dd>脆弱性を持ったサイト(以下，被害サイト)．ログイン機能がある．</dd>

  <dt>http://localhost:5000</dt>
  <dd>攻撃者の用意したサイト(以下，攻撃者サイト) ．</dd>
</dl>

## 攻撃手順

### 攻撃者サイトを準備

```bash
$ cd 20131117-tokumaru-benkyokai/sample-sites/ex00_WhatIsXSS
$ carton install  # 大体5分以上かかります・・・・
$ carton exec perl -Ilib script/ex00_whatisxss-server
$ browser http://localhost:5000
```

