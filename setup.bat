@echo off
chcp 65001 >nul

echo ========================================
echo OpenSearch Stack Simple Setup
echo ========================================
echo.

REM Docker check
docker version >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] Docker is not running. Please start Docker Desktop.
    pause
    exit /b 1
)
echo [OK] Docker is running

REM Create directories
if not exist script\create_directories.bat (
    echo [ERROR] script\create_directories.bat file does not exist
    pause
    exit /b 1
)
call script\create_directories.bat
if %errorLevel% neq 0 (
    echo [ERROR] Failed to create directories
    pause
    exit /b 1
)

REM Check .env file
echo [INFO] Checking .env file...
if not exist .env (
    echo [ERROR] .env file does not exist
    pause
    exit /b 1
)

REM Check configuration files
if not exist script\check_config.bat (
    echo [ERROR] script\check_config.bat file does not exist
    pause
    exit /b 1
)
call script\check_config.bat
if %errorLevel% neq 0 (
    echo [ERROR] Configuration check failed
    pause
    exit /b 1
)

REM Copy configuration files
if not exist script\copy_config.bat (
    echo [ERROR] script\copy_config.bat file does not exist
    pause
    exit /b 1
)
call script\copy_config.bat

REM Start services
echo [INFO] Starting OpenSearch stack...
echo [INFO] This may take a few minutes...
docker-compose up -d

if not %errorLevel% == 0 (
    echo [ERROR] Failed to start services
    echo [ERROR] Check logs: docker-compose logs
    exit /b 1
)

echo.
echo ========================================
echo Setup Complete!
echo ========================================
echo.
echo Access URLs:
echo   OpenSearch API: http://localhost:9200
echo   Dashboards: http://localhost:5601
echo.
echo Next steps:
echo   1. Wait 2-3 minutes for services to start
echo   2. Check status: docker-compose ps
echo   3. Check health: curl http://localhost:9200/_cluster/health
echo   4. Open Dashboards: http://localhost:5601
echo.

exit /b 0