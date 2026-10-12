# home-k8s-apps-site

自宅 Kubernetes で動かしている個人アプリの公開ページ（https://k8s.wanawata.com）。Google OAuth の同意画面に登録するアプリのホームページとプライバシーポリシーを置く。**認証なし**（Cloudflare Access のアプリをこのホストに作らない）。

| URL | 内容 | ファイル |
|---|---|---|
| `/` | アプリ一覧 | `chart/site/index.html` |
| `/my-knowledge/` | my-knowledge のホームページ（OAuth の「アプリのホームページ」） | `chart/site/my-knowledge/index.html` |
| `/privacy/` | プライバシーポリシー（OAuth の「プライバシー ポリシーのリンク」） | `chart/site/privacy/index.html` |

## 仕組み

- 静的ファイルは `chart/site/` に置き、Helm が ConfigMap にして nginx（`nginxinc/nginx-unprivileged`、非 root・読み取り専用ルート）に渡す。サイト用のイメージ・CI は無い。
- `cloudflare-tunnel` IngressClass が Tunnel 経由で公開し、DNS レコードも作る。
- Argo CD Application `home-k8s-apps-site`（namespace `tomorrow`、project `default`）が `main` の `chart/` を同期する。ページを直して `main` に push すれば反映される（ConfigMap のチェックサムで Pod が入れ替わる）。

## 初回登録

```
kubectl apply -n tomorrow -f argocd/application.yaml
```

## ページを足す

`chart/site/<path>/index.html` を置くだけ（ConfigMap のキーは `/` → `__` に変換される）。ConfigMap は 1 MiB までなので、画像を増やすならイメージ化を検討する。

## Google の OAuth 同意画面

- アプリのホームページ: `https://k8s.wanawata.com/my-knowledge/`
- プライバシー ポリシー: `https://k8s.wanawata.com/privacy/`
- 承認済みドメイン: `wanawata.com`（Google Search Console でドメインの所有確認が要る）

プライバシーポリシーは my-knowledge が実際に使うスコープ・保存先・第三者に合わせて書いている。スコープや処理を変えたら、このページも直す。
