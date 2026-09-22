# 本リポジトリについて
* こちらの記事の実装サンプル
  * https://zenn.dev/nsd_yst/articles/20260930-proxy-on-oci

# 構成要素
* common : 恒常的・共通的なリソースを管理
* proxy-vm : 暫定・個別的なリソースを管理。proxy squid が稼働

# 管理方法
* インフラコードは、HCP Terraform で実行している
  * ローカルにて、terraform plan, apply を実行すると、HCP Terraform 経由で API 実行される形式

# 前提
* OCI にて、以下のリソースが手動で作成されている
  * HCP terraform user -> APIキーを発行し、HCP Terraform に格納
  * HCP terraform用 policy -> 上記の権限管理
```
Allow group 'HCP Terraform Group' to manage instance-family in compartment <compartment名>
Allow group 'HCP Terraform Group' to manage volume-family in compartment <compartment名>
Allow group 'HCP Terraform Group' to manage virtual-network-family in compartment <compartment名>
```

# 役割
* cron で設定されている通り、以下の2つを行う
  * 19:00 JST squid proxy が起動
  * 21:00 JST squid proxy が停止
