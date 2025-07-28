# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is an OpenSearch Stack Docker Compose environment that provides a log analysis stack using OpenSearch and OpenSearch Dashboards as alternatives to Elasticsearch and Kibana. The stack includes OpenSearch (2-node cluster), OpenSearch Dashboards, Logstash, and Filebeat for log collection and analysis.

## Common Commands

### Setup and Start
```bash
# Windows setup
setup.bat

# Start all services
docker-compose up -d

# Check service status
docker-compose ps

# View logs of specific service
docker-compose logs -f opensearch-node1
docker-compose logs -f logstash
docker-compose logs -f filebeat
```

### Health Checks
```bash
# Check service health status
docker-compose ps

# Check OpenSearch cluster health
curl "localhost:9200/_cluster/health?pretty"

# Check indices
curl "localhost:9200/_cat/indices?v"

# Check nodes
curl "localhost:9200/_nodes/stats?pretty"

# Logstash monitoring
curl "localhost:9600/_node/stats?pretty"

# View health check logs
docker-compose logs opensearch-node1 | grep health
```

### Service Management
```bash
# Stop services
docker-compose down

# Restart specific service
docker-compose restart opensearch-node1

# Stop and remove all data (including volumes)
docker-compose down -v

# Scale services (requires docker-compose.yml modification)
docker-compose up -d --scale opensearch-node2=2
```

## Architecture

### Core Components
- **OpenSearch Node 1**: Master and data node (port 9200, 9600)
- **OpenSearch Node 2**: Data node
- **OpenSearch Dashboards**: Web UI for visualization (port 5601)
- **Logstash**: Log processing pipeline (ports 5044, 5000, 9600)
- **Filebeat**: Log collection agent

### Data Flow
1. **Filebeat** collects logs from `/var/log/app/*.log` and Docker containers
2. **Logstash** receives logs via beats input (port 5044), processes them, and forwards to OpenSearch
3. **OpenSearch** stores indexed logs in `logs-YYYY.MM.dd` indices
4. **OpenSearch Dashboards** provides visualization and search interface

### Configuration Structure
```
config/
├── OpenSearchDashboards/opensearch_dashboards.yml  # Dashboard config
├── Logstash/
│   ├── logstash.yml        # Logstash basic config
│   └── logstash.conf       # Pipeline configuration
└── Filebeat/filebeat.yml   # Log collection config

Volumes/  # Persistent data (auto-created by setup scripts)
├── OpenSearch/Node1/       # Node 1 data
├── OpenSearch/Node2/       # Node 2 data
├── OpenSearchDashboards/   # Dashboard config and data
├── Logstash/              # Logstash config and data
└── Filebeat/              # Filebeat config and logs
```

### Key Configuration Details
- **Security**: Disabled by default for development (`DISABLE_SECURITY_PLUGIN=true`)
- **Memory**: Default 512MB heap for OpenSearch nodes, 256MB for Logstash
- **Networking**: All services on `opensearch-net` bridge network
- **Index Pattern**: Logs stored as `logs-YYYY.MM.dd` with daily rotation
- **Log Processing**: Basic Logstash pipeline with beats input and OpenSearch output

## Environment Configuration

The stack uses environment variables that can be set in `.env` file:
- `OPENSEARCH_CLUSTER_NAME`: Cluster name (default: opensearch-cluster)
- `OPENSEARCH_JAVA_OPTS`: Java heap settings (default: -Xms512m -Xmx512m)
- `LOGSTASH_JAVA_OPTS`: Logstash heap settings (default: -Xmx256m -Xms256m)
- `OPENSEARCH_REST_PORT`: REST API port (default: 9200)
- `OPENSEARCH_DASHBOARDS_PORT`: Dashboard port (default: 5601)
- `DISABLE_SECURITY_PLUGIN`: Security plugin toggle (default: true)

## Access Information

| Service | URL | Purpose |
|---------|-----|---------|
| OpenSearch API | http://localhost:9200 | REST API and cluster operations |
| OpenSearch Dashboards | http://localhost:5601 | Web UI for log analysis and visualization |
| Logstash Monitoring | http://localhost:9600 | Logstash node stats and monitoring |

## Common Development Tasks

### Adding New Log Sources
1. Edit `config/Filebeat/filebeat.yml` to add new input paths
2. Update `config/Logstash/logstash.conf` for custom parsing if needed
3. Restart services: `docker-compose restart filebeat logstash`

### Modifying Pipeline Processing
1. Edit `config/Logstash/logstash.conf` for filter modifications
2. Restart Logstash: `docker-compose restart logstash`
3. Monitor processing: `curl "localhost:9600/_node/stats/pipelines?pretty"`

### Environment Switching
1. Create environment-specific .env files
2. Copy desired config: `copy .env.production .env`
3. Restart stack: `docker-compose down && docker-compose up -d`