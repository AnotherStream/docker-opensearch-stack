@echo off
chcp 65001 >nul

echo [INFO] Copying configuration files...

REM Copy OpenSearch Dashboards config
set "DEST_PATH=Volumes\OpenSearchDashboards\usr\share\opensearch-dashboards\config\opensearch_dashboards.yml"
if exist "%DEST_PATH%" (
    echo [SKIP] OpenSearch Dashboards config already exists
) else (
    copy "config\OpenSearchDashboards\opensearch_dashboards.yml" "%DEST_PATH%" >nul 2>&1
    if %errorLevel% neq 0 (
        echo [WARN] Failed to copy OpenSearch Dashboards config
    ) else (
        echo [OK] OpenSearch Dashboards config copied
    )
)

REM Copy Logstash config
set "DEST_PATH=Volumes\Logstash\usr\share\logstash\config\logstash.yml"
if exist "%DEST_PATH%" (
    echo [SKIP] Logstash config already exists
) else (
    copy "config\Logstash\logstash.yml" "%DEST_PATH%" >nul 2>&1
    if %errorLevel% neq 0 (
        echo [WARN] Failed to copy Logstash config
    ) else (
        echo [OK] Logstash config copied
    )
)

REM Copy Logstash pipeline
set "DEST_PATH=Volumes\Logstash\usr\share\logstash\pipeline\logstash.conf"
if exist "%DEST_PATH%" (
    echo [SKIP] Logstash pipeline already exists
) else (
    copy "config\Logstash\logstash.conf" "%DEST_PATH%" >nul 2>&1
    if %errorLevel% neq 0 (
        echo [WARN] Failed to copy Logstash pipeline
    ) else (
        echo [OK] Logstash pipeline copied
    )
)

REM Copy Filebeat config
set "DEST_PATH=Volumes\Filebeat\usr\share\filebeat\filebeat.yml"
if exist "%DEST_PATH%" (
    echo [SKIP] Filebeat config already exists
) else (
    copy "config\Filebeat\filebeat.yml" "%DEST_PATH%" >nul 2>&1
    if %errorLevel% neq 0 (
        echo [WARN] Failed to copy Filebeat config
    ) else (
        echo [OK] Filebeat config copied
    )
)

echo [INFO] Configuration file processing completed

exit /b 0