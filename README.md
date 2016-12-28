(Japanese)

# Pacemaker リポジトリパッケージ用 Ansible Playbook

このリポジトリは、Linux-HA Japan Pacemaker リポジトリパッケージを
インストールする手順を Ansible で自動化した Playbook の例です。

## 対象バージョン・手順

以下のページに記載されているバージョン・手順を Ansible Playbook にしたものです。

* 対象バージョン: pacemaker-repo-1.1.14-1.1
* 手順: [Pacemaker-1.1.14-1.1 リポジトリパッケージ](http://linux-ha.osdn.jp/wp/archives/4490)

以前のバージョンを利用する場合は、対応するタグを checkout して使ってください。

* pacemaker-repo-1.1.14-1.1: タグ [1.1.14-1.1](https://github.com/kskmori/ansible-pacemaker/tree/1.1.14-1.1)
* pacemaker-repo-1.1.13-1.1: タグ [1.1.13-1.1](https://github.com/kskmori/ansible-pacemaker/tree/1.1.13-1.1)

## 前提条件

この　playbook を使うには以下の設定をあらかじめ行っておいてください。

* OSメディアもしくはリポジトリが参照できるように /etc/yum.repo.d を設定しておくこと(OS標準の依存パッケージを自動的にインストールするため)
* OSおよびネットワークの設定は別途完了済みであること。
* firewalld サービスを停止しておくこと(もしくは corosync に必要な通信を許可しておくこと)。

## 設定

以下のファイルを環境に合わせ設定します。詳細はファイルの中身を参照してください。

* hosts
  * インベントリファイル。hosts.sample を参考に構築対象ホスト名を修正して作成してください。
* group_vars/hacluster
  * ノード間通信に使用するネットワークアドレス、マルチキャストアドレス・ポート、ログ出力先を設定します。

## 実行例

* (1) リポジトリパッケージのダウンロード
  * リポジトリパッケージをダウンロードします。インターネットに接続されてない環境では、別途ファイルをダウンロードして roles/pacemaker-install/files 配下に手動でコピーしても構いません。

>     $ ansible-playbook 00-download.yml

* (2) Pacemaker リポジトリパッケージのインストール
  * Pacemaker / Corosync のインストールと必要最低限の設定を行います。

>     $ ansible-playbook -i hosts 10-pacemaker-install.yml 

* (3) Pacemaker の起動
  * Pacemaker クラスタを起動します。

>     $ ansible-playbook -i hosts 20-pacemaker-start.yml 

* (4) Pacemaker の停止
  * Pacemaker クラスタを停止します。

>     $ ansible-playbook -i hosts 30-pacemaker-stop.yml 

* (5) Pacemaker リポジトリパッケージのアンインストール
  * Pacemaker リポジトリパッケージを全てアンインストールします。確認のプロンプトが出ます。
  * デフォルトでは Pacemaker のCRMクラスタ設定(CIB設定)は削除しませんが、`-e REMOVE_CIB=true` オプションを付与することでCRMクラスタ設定も全て削除します。

>     $ ansible-playbook -i hosts 90-pacemaker-uninstall.yml 

  * CRMクラスタ設定も全て削除する場合

>     $ ansible-playbook -i hosts -e REMOVE_CIB=true 9-pacemaker-uninstall.yml


## 補足

* この playbook には Pacemaker を単体で起動するために必要最低限の手順のみが含まれています。実際のクラスタ環境構築を全て自動化するには、ネットワーク設定や監視対象のアプリケーションなども含め適宜手順を追加して利用してください。
* playbook のファイル名の数字は単にファイル名のソート順のために付与したもので深い意味はありません。
