# OpenSearch Stack with Docker Compose

このDocker Compose環境は、ElasticsearchとKibanaの代替として、OpenSearchとOpenSearch Dashboardsを使用したログ分析スタックを提供します。

## 構成要素

- **OpenSearch** (2ノードクラスター): Elasticsearch相当の検索・分析エンジン
- **OpenSearch Dashboards**: Kibana相当の可視化・分析ツール
- **Logstash**: ログ処理パイプライン
- **Filebeat**: ログ収集エージェント

## クイックスタート

### 1. 前提条件

#### Linux / macOS
- Docker & Docker Compose
- 最低4GB以上のメモリ
- Linux環境の場合: `vm.max_map_count >= 262144`

#### Windows
- **Docker Desktop for Windows** （WSL2バックエンド推奨）
- **Windows 10 version 2004** 以降 または **Windows 11**
- **WSL2** が有効化されていること
- **最低8GB以上のメモリ**

### 2. セットアップ

#### Linux / macOS
```bash
# .envファイルで設定をカスタマイズ（オプション）
cp .env .env.local
vim .env.local  # 必要に応じて設定を変更

# セットアップスクリプトを実行
chmod +x setup.sh
./setup.sh
```

#### Windows
```cmd
REM Windows用設定ファイルをコピー
copy .env.windows .env

REM セットアップスクリプトを実行（いずれかの方法）
setup.bat
REM または
powershell .\setup.ps1
```

#### WSL2内での使用（Windows推奨）
```bash
wsl
cd /path/to/project
chmod +x setup.sh
./setup.sh
```

### 3. 手動セットアップ（オプション）

#### Linux / macOS
```bash
# .envファイルを読み込み
source .env

# 必要なディレクトリ作成
mkdir -p ${OPENSEARCH_NODE1_DATA_PATH}
mkdir -p ${OPENSEARCH_NODE2_DATA_PATH}
mkdir -p ${DASHBOARDS_CONFIG_PATH}
mkdir -p ${DASHBOARDS_DATA_PATH}

# vm.max_map_count設定（Linux）
sudo sysctl -w vm.max_map_count=262144

# 設定ファイルを作成（各ファイルの内容は setup.sh を参照）

# 権限設定
sudo chown -R 1000:1000 $(dirname ${OPENSEARCH_NODE1_DATA_PATH})/..
sudo chown -R 1000:1000 $(dirname ${DASHBOARDS_CONFIG_PATH})/..
sudo chown -R 1000:1000 $(dirname ${LOGSTASH_CONFIG_PATH})/..
sudo chown -R root:root $(dirname ${FILEBEAT_CONFIG_PATH})/..

# サービス起動
docker-compose up -d
```

#### Windows
```cmd
REM 必要なディレクトリを作成
mkdir Volumes\OpenSearch\Node1\usr\share\opensearch\data
mkdir Volumes\OpenSearch\Node2\usr\share\opensearch\data
mkdir Volumes\OpenSearchDashboards\usr\share\opensearch-dashboards\config
mkdir Volumes\OpenSearchDashboards\usr\share\opensearch-dashboards\data

REM Docker Desktopが起動していることを確認
docker version

REM サービスを起動
docker-compose up -d
```

## 設定管理（.envファイル）

すべての設定は`.env`ファイルで管理されています。主要な設定項目：

### 基本設定
```bash
# クラスター名
OPENSEARCH_CLUSTER_NAME=opensearch-cluster

# メモリ設定
OPENSEARCH_JAVA_OPTS=-Xms512m -Xmx512m
LOGSTASH_JAVA_OPTS=-Xmx256m -Xms256m

# ポート設定
OPENSEARCH_REST_PORT=9200
OPENSEARCH_DASHBOARDS_PORT=5601
```

### 開発環境用設定
```bash
# セキュリティ無効化
DISABLE_SECURITY_PLUGIN=true
DISABLE_SECURITY_DASHBOARDS_PLUGIN=true

# デバッグ出力
LOGSTASH_STDOUT_DEBUG=true
FILEBEAT_LOG_LEVEL=info
```

### 本番環境用設定
```bash
# セキュリティ有効化
DISABLE_SECURITY_PLUGIN=false
DISABLE_SECURITY_DASHBOARDS_PLUGIN=false

# メモリ増加
OPENSEARCH_JAVA_OPTS=-Xms2g -Xmx2g
LOGSTASH_JAVA_OPTS=-Xmx1g -Xms1g
```

## アクセス情報

| サービス | URL | 説明 |
|----------|-----|------|
| OpenSearch | http://localhost:9200 | REST API |
| OpenSearch Dashboards | http://localhost:5601 | Web UI |

## ファイル構成

```
opensearch-stack/
├── .env                                # 環境設定ファイル（メイン）
├── .env.windows                        # Windows用設定例
├── docker-compose.yml                 # Docker Compose設定
├── setup.sh                          # セットアップスクリプト（Linux/macOS）
├── setup.bat                         # セットアップスクリプト（Windows）
├── setup.ps1                         # セットアップスクリプト（PowerShell）
├── README.md                         # このファイル
│
└── Volumes/                          # 永続化データ用ディレクトリ
    ├── OpenSearch/                   # OpenSearchデータ
    │   ├── Node1/usr/share/opensearch/data/
    │   └── Node2/usr/share/opensearch/data/
    ├── OpenSearchDashboards/         # OpenSearch Dashboards設定・データ
    │   └── usr/share/opensearch-dashboards/
    │       ├── config/opensearch_dashboards.yml
    │       └── data/
    ├── Logstash/                     # Logstash設定・データ
    │   └── usr/share/logstash/
    │       ├── config/logstash.yml
    │       └── pipeline/logstash.conf
    └── Filebeat/                     # Filebeat設定・ログデータ
        ├── usr/share/filebeat/filebeat.yml
        └── var/
            ├── log/app/
            │   ├── app.log
            │   └── nginx/access.log
            ├── lib/docker/containers/
            └── run/docker.sock
```

## 主要な機能

### ログ収集
- FilebeatがローカルファイルとDockerコンテナログを収集
- Logstashでログの解析・変換・拡張
- OpenSearchにインデックス化して保存

### ログ解析パターン
- **アプリケーションログ**: タイムスタンプ、ログレベル、メッセージの解析
- **Nginxアクセスログ**: IPアドレス、レスポンスコード、ユーザーエージェントなどの解析
- **Dockerコンテナログ**: コンテナメタデータの自動付与

### 可視化
- OpenSearch Dashboardsでリアルタイム監視
- カスタムダッシュボードの作成
- アラートとモニタリング

## 基本的な使い方

### 1. 環境変数での設定変更
```bash
# 開発環境用（デフォルト）
OPENSEARCH_JAVA_OPTS=-Xms512m -Xmx512m
DISABLE_SECURITY_PLUGIN=true

# ステージング環境用
OPENSEARCH_JAVA_OPTS=-Xms1g -Xmx1g
LOGSTASH_STDOUT_DEBUG=false

# 本番環境用
OPENSEARCH_JAVA_OPTS=-Xms2g -Xmx2g
DISABLE_SECURITY_PLUGIN=false
```

### 2. インデックス確認
```bash
# .envから設定を読み込み
source .env
curl "localhost:${OPENSEARCH_REST_PORT}/_cat/indices?v"
```

### 3. ログ検索
```bash
source .env
curl -X GET "localhost:${OPENSEARCH_REST_PORT}/logs-*/_search?pretty" \
  -H 'Content-Type: application/json' \
  -d '{"query": {"match": {"level": "ERROR"}}}'
```

### 4. 設定の動的変更
```bash
# .envファイルを編集
vim .env

# サービスを再起動して設定を反映
docker-compose down
docker-compose up -d
```

### 5. ダッシュボード作成
```bash
# .envから設定を読み込み
source .env
```
1. http://localhost:${OPENSEARCH_DASHBOARDS_PORT} にアクセス
2. 左メニューから「Management」→「Index Patterns」
3. `logs-*` パターンを作成
4. 「Discover」でログを確認
5. 「Dashboard」でカスタム可視化を作成

## 環境別設定例

### 開発環境
```bash
# .env.development
OPENSEARCH_JAVA_OPTS=-Xms512m -Xmx512m
LOGSTASH_JAVA_OPTS=-Xmx256m -Xms256m
DISABLE_SECURITY_PLUGIN=true
LOGSTASH_STDOUT_DEBUG=true
FILEBEAT_LOG_LEVEL=debug
```

### 本番環境
```bash
# .env.production
OPENSEARCH_JAVA_OPTS=-Xms4g -Xmx4g
LOGSTASH_JAVA_OPTS=-Xmx2g -Xms2g
DISABLE_SECURITY_PLUGIN=false
LOGSTASH_STDOUT_DEBUG=false
FILEBEAT_LOG_LEVEL=error

# 本番用ポート設定
OPENSEARCH_REST_PORT=9200
OPENSEARCH_DASHBOARDS_PORT=5601
```

### マルチ環境の管理
```bash
# 開発環境で起動
cp .env.development .env
./setup.sh

# 本番環境で起動
cp .env.production .env
./setup.sh
```

## 設定ファイルの詳細

### OpenSearch Dashboards設定
`Volumes/OpenSearchDashboards/usr/share/opensearch-dashboards/config/opensearch_dashboards.yml`
- 日本語ロケール設定
- セキュリティプラグイン無効化
- データ永続化設定
- ログ出力設定

### Logstash設定
- `Volumes/Logstash/usr/share/logstash/config/logstash.yml`: 基本設定
- `Volumes/Logstash/usr/share/logstash/pipeline/logstash.conf`: パイプライン設定

### Filebeat設定
`Volumes/Filebeat/usr/share/filebeat/filebeat.yml`
- アプリケーションログとNginxログの収集
- Dockerコンテナログの収集
- Logstashへの出力設定

## Windows環境での使用方法

### Windows固有の設定

#### WSL2メモリ設定
`%USERPROFILE%\.wslconfig` ファイルを作成/編集：

```ini
[wsl2]
memory=8GB
processors=4
swap=2GB
```

設定後、WSL2を再起動：
```cmd
wsl --shutdown
```

#### Docker Desktop設定
1. **Settings** → **Resources** → **Advanced** で以下を設定：
   - **Memory**: 6GB以上
   - **CPUs**: 2以上
   - **Disk image size**: 60GB以上

2. **Settings** → **General** で以下を有効化：
   - ☑ Use the WSL 2 based engine

### Windows用セットアップ方法

#### バッチファイル使用
```cmd
setup.bat
```

#### PowerShell使用（推奨）
```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
.\setup.ps1
```

#### WSL2内で使用（最高パフォーマンス）
```bash
wsl
cd /path/to/project
chmod +x setup.sh
./setup.sh
```

### Windows特有の注意点

#### ファイルパス
- Windowsではバックスラッシュ（`\`）を使用
- .envファイルでは`%VOLUMES_ROOT%`形式で変数を定義

#### パフォーマンス最適化
1. **ファイルシステムの配置**
```cmd
REM WSL2内にプロジェクトを配置（推奨）
wsl
cd /home/username/
git clone <repository> opensearch-stack
cd opensearch-stack
```

2. **Antivirus除外設定**
以下のディレクトリをAntivirusスキャンから除外：
- `%USERPROFILE%\.docker`
- `%LOCALAPPDATA%\Docker`
- プロジェクトディレクトリ

## トラブルシューティング

### 共通の問題

#### メモリ不足エラー
```bash
# Javaヒープサイズを調整（.envファイル内）
OPENSEARCH_JAVA_OPTS=-Xms256m -Xmx256m
LOGSTASH_JAVA_OPTS=-Xmx128m -Xms128m
```

#### ログが表示されない場合
```bash
# サービス状態確認
docker-compose ps

# ログ確認
docker-compose logs filebeat
docker-compose logs logstash

# インデックス確認
source .env
curl "localhost:${OPENSEARCH_REST_PORT}/_cat/indices?v"
```

#### パフォーマンス調整
- ノード数の調整: `docker-compose.yml`のOpenSearchノード設定
- メモリ割り当て: `.env`ファイルの`JAVA_OPTS`設定
- シャード・レプリカ設定: インデックステンプレートで調整

### Linux固有の問題

#### vm.max_map_count設定
```bash
# 現在の値を確認
cat /proc/sys/vm/max_map_count

# 一時的に設定
sudo sysctl -w vm.max_map_count=262144

# 永続的に設定
echo 'vm.max_map_count=262144' | sudo tee -a /etc/sysctl.conf
```

#### 権限エラー
```bash
# 権限再設定
sudo chown -R 1000:1000 Volumes/OpenSearch/
sudo chown -R 1000:1000 Volumes/OpenSearchDashboards/
sudo chown -R 1000:1000 Volumes/Logstash/
sudo chown -R root:root Volumes/Filebeat/
```

### Windows固有の問題

#### Docker Desktopが起動しない
```cmd
REM サービスを再起動
net stop com.docker.service
net start com.docker.service
```

#### WSL2でメモリ不足
```cmd
REM WSL2のメモリ使用量確認
wsl -l -v
wsl --shutdown
```

#### ポート競合エラー
```cmd
REM ポート使用状況確認
netstat -ano | findstr :9200
netstat -ano | findstr :5601
```

#### ファイル権限エラー
PowerShell（管理者権限）で実行：
```powershell
# Dockerに必要な権限を付与
icacls ".\Volumes" /grant Users:(OI)(CI)F /T
```

#### パフォーマンスが遅い
```cmd
REM WSL2の統計情報確認
wsl --status

REM Docker統計情報確認
docker stats
```

## セキュリティ

この設定は開発・テスト環境向けです。本番環境では以下を考慮してください：

### セキュリティ強化項目
- OpenSearchセキュリティプラグインの有効化
- HTTPS/TLS暗号化の設定
- 認証・認可の実装
- ネットワークセキュリティの強化
- 定期的なセキュリティアップデート

### 本番環境用設定例
```bash
# .env.production.secure
DISABLE_SECURITY_PLUGIN=false
DISABLE_SECURITY_DASHBOARDS_PLUGIN=false

# SSL設定
OPENSEARCH_USE_SSL=true
DASHBOARDS_USE_SSL=true

# 認証設定
OPENSEARCH_USERNAME=admin
OPENSEARCH_PASSWORD=secure_password

# ネットワーク制限
OPENSEARCH_NETWORK_HOST=127.0.0.1
```

## カスタマイズ

### 新しいログタイプの追加
1. `.env`ファイルでFilebeat設定パスを確認
2. `${FILEBEAT_CONFIG_PATH}`にinput設定追加
3. `${LOGSTASH_PIPELINE_PATH}/logstash.conf`にfilter設定追加
4. Docker Composeを再起動

#### 例：Apache2ログの追加
```yaml
# Filebeat設定追加
- type: log
  enabled: true
  paths:
    - /var/log/app/apache2/access.log
  fields:
    logtype: apache-access
  fields_under_root: false
```

```ruby
# Logstash設定追加
if [fields][logtype] == "apache-access" {
  grok {
    match => { "message" => "%{COMBINEDAPACHELOG}" }
  }
}
```

### 複数環境での管理
```bash
# 環境別ディレクトリ構成
environments/
├── development/
│   ├── .env
│   └── docker-compose.override.yml
├── staging/
│   ├── .env
│   └── docker-compose.override.yml
└── production/
    ├── .env
    └── docker-compose.override.yml

# 環境切り替え
ln -sf environments/production/.env .env
docker-compose up -d
```

### アラート設定
OpenSearch Dashboardsの「Alerting」機能を使用してカスタムアラートを設定可能

#### アラート例
1. エラーログ検知アラート
2. ディスク使用量監視
3. レスポンス時間監視
4. サービス死活監視

## サービス管理

### 基本コマンド
```bash
# サービス状態確認
docker-compose ps

# サービス停止
docker-compose down

# サービス再起動
docker-compose restart

# 特定サービスの再起動
docker-compose restart opensearch-node1

# ログ確認
docker-compose logs -f opensearch-node1

# ボリューム含む完全削除
docker-compose down -v
```

### バックアップとリストア
```bash
# データディレクトリのバックアップ
tar -czf opensearch-backup-$(date +%Y%m%d).tar.gz Volumes/

# リストア
tar -xzf opensearch-backup-20231201.tar.gz
```

### スケーリング
```bash
# ノード数を増やす（docker-compose.ymlの編集が必要）
docker-compose up -d --scale opensearch-node2=2
```

## 監視とメトリクス

### OpenSearch APIによる監視
```bash
# クラスター状態
curl "localhost:9200/_cluster/health?pretty"

# ノード情報
curl "localhost:9200/_nodes/stats?pretty"

# インデックス統計
curl "localhost:9200/_stats?pretty"

# シャード情報
curl "localhost:9200/_cat/shards?v"
```

### Logstash監視
```bash
# Logstash統計情報
curl "localhost:9600/_node/stats?pretty"

# パイプライン情報
curl "localhost:9600/_node/stats/pipelines?pretty"
```

## 参考資料

### 公式ドキュメント
- [OpenSearch Documentation](https://opensearch.org/docs/)
- [OpenSearch Dashboards](https://opensearch.org/docs/dashboards/)
- [Logstash Configuration](https://www.elastic.co/guide/en/logstash/current/configuration.html)
- [Filebeat Configuration](https://www.elastic.co/guide/en/beats/filebeat/current/filebeat-configuration.html)

### コミュニティリソース
- [OpenSearch GitHub](https://github.com/opensearch-project)
- [OpenSearch Forum](https://forum.opensearch.org/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)

### トレーニング・学習リソース
- [OpenSearch Getting Started Guide](https://opensearch.org/docs/latest/getting-started/)
- [Elasticsearch to OpenSearch Migration Guide](https://opensearch.org/docs/latest/migration/)

## ライセンス

このプロジェクトで使用されているソフトウェアのライセンス：

- **OpenSearch**: Apache License 2.0
- **OpenSearch Dashboards**: Apache License 2.0
- **Logstash**: Elastic License (OSS version)
- **Filebeat**: Elastic License (OSS version)

## 貢献・サポート

### 問題報告
問題や改善提案がある場合は、以下の情報を含めてIssueを作成してください：

1. 使用環境（OS、Docker version、メモリサイズ）
2. 実行したコマンド
3. エラーメッセージ
4. 期待した動作と実際の動作

### 開発への貢献
1. このリポジトリをフォーク
2. 機能ブランチを作成
3. 変更をコミット
4. プルリクエストを作成

## 更新履歴

### v1.0.0
- 初回リリース
- OpenSearch 2.11.1対応
- 環境変数による設定管理
- Windows対応（バッチファイル・PowerShell）
- 日本語対応
- 自動セットアップスクリプト