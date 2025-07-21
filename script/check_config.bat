@echo off
chcp 65001 >nul

echo [INFO] Checking configuration files...

REM Check OpenSearch Dashboards config
set "CONFIG_PATH=config\OpenSearchDashboards\opensearch_dashboards.yml"
if not exist "%CONFIG_PATH%" (
    echo [ERROR] %CONFIG_PATH% file does not exist
    exit /b 1
)
echo [OK] OpenSearch Dashboards config exists

REM Check Logstash config
set "CONFIG_PATH=config\Logstash\logstash.yml"
if not exist "%CONFIG_PATH%" (
    echo [ERROR] %CONFIG_PATH% file does not exist
    exit /b 1
)
echo [OK] Logstash config exists

REM Check Logstash pipeline
set "CONFIG_PATH=config\Logstash\logstash.conf"
if not exist "%CONFIG_PATH%" (
    echo [ERROR] %CONFIG_PATH% file does not exist
    exit /b 1
)
echo [OK] Logstash pipeline exists

REM Check Filebeat config
set "CONFIG_PATH=config\Filebeat\filebeat.yml"
if not exist "%CONFIG_PATH%" (
    echo [ERROR] %CONFIG_PATH% file does not exist
    exit /b 1
)
echo [OK] Filebeat config exists

echo [OK] All configuration files exist

exit /b 0