(Japanese)

# Pacemaker リポジトリパッケージ用 Ansible Playbook

このリポジトリは、Linux-HA Japan Pacemaker リポジトリパッケージを
インストールする手順を Ansible で自動化した Playbook の例です。

## 対象バージョン・手順

以下のページに記載されているバージョン・手順を Ansible Playbook にしたものです。

* 対象バージョン: pacemaker-repo-1.1.17-1.1
* 手順: [Pacemaker-1.1.17-1.1 リポジトリパッケージ](http://linux-ha.osdn.jp/wp/archives/4676)

以前のバージョンを利用する場合は、対応するブランチを checkout して使ってください。

* pacemaker-repo-1.1.17-1.1: ブランチ [branch-1.1.17-1.1](https://github.com/kskmori/ansible-pacemaker/tree/branch-1.1.17-1.1)
* pacemaker-repo-1.1.16-1.1: ブランチ [branch-1.1.16-1.1](https://github.com/kskmori/ansible-pacemaker/tree/branch-1.1.16-1.1)
* pacemaker-repo-1.1.15-1.1: ブランチ [branch-1.1.15-1.1](https://github.com/kskmori/ansible-pacemaker/tree/branch-1.1.15-1.1)
* pacemaker-repo-1.1.14-1.1: ブランチ [branch-1.1.14-1.1](https://github.com/kskmori/ansible-pacemaker/tree/branch-1.1.14-1.1)
* pacemaker-repo-1.1.13-1.1: ブランチ [branch-1.1.13-1.1](https://github.com/kskmori/ansible-pacemaker/tree/branch-1.1.13-1.1)

_※ 2017/04/14追記: 以前はタグと記載していましたが、タグではなくブランチを checkout してください。各バージョンごとに必要な修正や更新などをそれぞれのブランチごとに反映しています。_

## 前提条件

この　playbook を使うには以下の設定をあらかじめ行っておいてください。

* OSメディアもしくはリポジトリが参照できるように /etc/yum.repo.d を設定しておくこと(OS標準の依存パッケージを自動的にインストールするため)
* OSおよびネットワークの設定は別途完了済みであること。
* firewalld が利用できない環境(RHEL6等)では、corosync に必要な通信を許可しておくこと(iptables -F など)。
  * RHEL7 で firewalld を利用している環境では不要です。この playbook が必要な設定を行います。

## 設定

以下のファイルを環境に合わせ設定します。詳細はファイルの中身を参照してください。

* hosts
  * インベントリファイル。hosts.sample を参考に構築対象ホスト名を修正して作成してください。
* group_vars/hacluster
  * ノード間通信に使用するネットワークアドレス、マルチキャストアドレス・ポート、ログ出力先を設定します。
  * group_vars/hacluster.sample を参考に修正して作成してください。
  * _※ 2017/01/13[(e7dd854)](https://github.com/kskmori/ansible-pacemaker/commit/e7dd854)以降、haclusterの設定書式をよりシンプルに変更しました。これより前に作成された方は注意願います。_

## 実行例

* (1) リポジトリパッケージのダウンロード
  * リポジトリパッケージをダウンロードします。インターネットに接続されてない環境では、別途ファイルをダウンロードして roles/pacemaker-install/files 配下に手動でコピーしても構いません。

>     $ ansible-playbook 00-download.yml

* (2) Pacemaker リポジトリパッケージのインストール
  * Pacemaker / Corosync のインストールと必要最低限の設定を行います。

>     $ ansible-playbook -u root -i hosts 10-pacemaker-install.yml

* (3) Pacemaker の起動
  * Pacemaker クラスタを起動します。

>     $ ansible-playbook -u root -i hosts 20-pacemaker-start.yml

* (4) Pacemaker の停止
  * Pacemaker クラスタを停止します。

>     $ ansible-playbook -u root -i hosts 30-pacemaker-stop.yml

* (5) Pacemaker リポジトリパッケージのアンインストール
  * Pacemaker リポジトリパッケージを全てアンインストールします。確認のプロンプトが出ます。
  * デフォルトでは Pacemaker のCRMクラスタ設定(CIB設定)は削除しませんが、`-e REMOVE_CIB=true` オプションを付与することでCRMクラスタ設定も全て削除します。

>     $ ansible-playbook -u root -i hosts 99-pacemaker-uninstall.yml

  * CRMクラスタ設定も全て削除する場合

>     $ ansible-playbook -u root -i hosts -e REMOVE_CIB=true 99-pacemaker-uninstall.yml

## Linux-HA Japan 追加パッケージ利用例

本 playbook には、Linux-HA Japan リポジトリパッケージに含まれる pm_logconv-cs (Pacemakerログ解析支援ツール)を利用する場合の playbook も含まれています。

これは下記の pm_logconv-cs のドキュメントに記載されている設定を playbook 化したものです。
詳細は pm_logconv-cs の README.md を参照してください。

* Pacemakerログ解析支援ツール（pm_logconv-cs）
  * https://github.com/linux-ha-japan/pm_logconv-cs/blob/master/README.md

### 設定

設定のサンプルは group_vars/hacluster.pm_logconv を参照してください。

### 実行例

* (1) Pacemaker リポジトリパッケージのインストール・pm_logconv-cs の有効化
  * Pacemaker / Corosync のインストールと必要最低限の設定を行います。
  * 続けて、pm_logconv-cs 利用に必要な /etc/rsyslog.conf 等の設定を行います。

>     $ ansible-playbook -u root -i hosts 10-pacemaker-install.yml
>     $ ansible-playbook -u root -i hosts 11-pacemaker-tools-enable.yml

* (2) Pacemaker の起動
  * Pacemaker クラスタを起動します。
  * /var/log/pm_logconv.out にログが出力されることを確認します。

>     $ ansible-playbook -u root -i hosts 20-pacemaker-start.yml

* (3) Pacemaker の停止
  * Pacemaker クラスタを停止します。

>     $ ansible-playbook -u root -i hosts 30-pacemaker-stop.yml

* (4) pm_logconv-cs設定の無効化・Pacemaker リポジトリパッケージのアンインストール
  * pm_logconv-cs 有効化のために設定した /etc/rsyslog.conf 等を元に戻します(元に戻す必要がない場合は実行は必須ではありません)。

>     $ ansible-playbook -u root -i hosts 98-pacemaker-tools-disable.yml
>     $ ansible-playbook -u root -i hosts 99-pacemaker-uninstall.yml


## 補足

* この playbook には Pacemaker を単体で起動するために必要最低限の手順のみが含まれています。実際のクラスタ環境構築を全て自動化するには、ネットワーク設定や監視対象のアプリケーションなども含め適宜手順を追加して利用してください。
* playbook のファイル名の数字は単にファイル名のソート順のために付与したもので深い意味はありません。
