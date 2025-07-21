@echo off
chcp 65001 >nul

echo [INFO] Creating directory structure...

REM Create base directory
if not exist Volumes mkdir Volumes >nul 2>&1

REM OpenSearch Node1 directories
set "DIR_PATH=Volumes\OpenSearch\Node1\usr\share\opensearch\data"
if not exist "%DIR_PATH%" mkdir "%DIR_PATH%" >nul 2>&1

REM OpenSearch Node2 directories  
set "DIR_PATH=Volumes\OpenSearch\Node2\usr\share\opensearch\data"
if not exist "%DIR_PATH%" mkdir "%DIR_PATH%" >nul 2>&1

REM OpenSearch Dashboards directories
set "DIR_PATH=Volumes\OpenSearchDashboards\usr\share\opensearch-dashboards\config"
if not exist "%DIR_PATH%" mkdir "%DIR_PATH%" >nul 2>&1
set "DIR_PATH=Volumes\OpenSearchDashboards\usr\share\opensearch-dashboards\data"
if not exist "%DIR_PATH%" mkdir "%DIR_PATH%" >nul 2>&1

REM Logstash directories
set "DIR_PATH=Volumes\Logstash\usr\share\logstash\config"
if not exist "%DIR_PATH%" mkdir "%DIR_PATH%" >nul 2>&1
set "DIR_PATH=Volumes\Logstash\usr\share\logstash\pipeline"
if not exist "%DIR_PATH%" mkdir "%DIR_PATH%" >nul 2>&1
set "DIR_PATH=Volumes\Logstash\usr\share\logstash\data"
if not exist "%DIR_PATH%" mkdir "%DIR_PATH%" >nul 2>&1

REM Filebeat directories
set "DIR_PATH=Volumes\Filebeat\usr\share\filebeat"
if not exist "%DIR_PATH%" mkdir "%DIR_PATH%" >nul 2>&1
set "DIR_PATH=Volumes\Filebeat\var\log\app\nginx"
if not exist "%DIR_PATH%" mkdir "%DIR_PATH%" >nul 2>&1
set "DIR_PATH=Volumes\Filebeat\var\lib\docker\containers"
if not exist "%DIR_PATH%" mkdir "%DIR_PATH%" >nul 2>&1
set "DIR_PATH=Volumes\Filebeat\var\run"
if not exist "%DIR_PATH%" mkdir "%DIR_PATH%" >nul 2>&1

echo [OK] Directory structure created

exit /b 0