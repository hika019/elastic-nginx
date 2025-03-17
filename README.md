# 概要
nginxのログをElastic Searchで可視化するためのdocker composeです

# 実行方法
1. elastic searchとkibanaを実行
    ```bash
    docker compose up -d kibana
    ```

1. nginxのログをjson形式に変更する。
    ```bash
    vim /etc/nginx/nginx.conf
    ```
    ```conf
    ...

    http{

    ...

    log_format json escape=json '{"time":"$time_iso8601",'
                    '"ip":"$remote_addr",'
                    '"port":$remote_port,'
                    '"method":"$request_method",'
                    '"uri":"$request_uri",'
                    '"status":"$status",'
                    '"body_bytes":$body_bytes_sent,'
                    '"referer":"$http_referer",'
                    '"ua":"$http_user_agent",'
                    '"request_time":"$request_time",'
                    '"response_time":"$upstream_response_time"}';

            access_log /var/log/nginx/access.log json;

    }

    ...
    ```

1. nginxのログ出力先のディレクトリをBeatsにマウントする。
1. beatsの起動
    ```bash
    docker compose up -d beats
    ```

---

## Overview
This is a Docker Compose setup for visualizing Nginx logs using Elasticsearch.

# How to Run
1. Start Elasticsearch and Kibana:
    ```bash
    docker compose up -d kibana
    ```

1. Modify the Nginx log format to JSON:

   Edit the Nginx configuration file:
    ```bash
    vim /etc/nginx/nginx.conf
    ```

    Update the log format in nginx.conf:
    ```conf
    ...

    http{

    ...

    log_format json escape=json '{"time":"$time_iso8601",'
                    '"ip":"$remote_addr",'
                    '"port":$remote_port,'
                    '"method":"$request_method",'
                    '"uri":"$request_uri",'
                    '"status":"$status",'
                    '"body_bytes":$body_bytes_sent,'
                    '"referer":"$http_referer",'
                    '"ua":"$http_user_agent",'
                    '"request_time":"$request_time",'
                    '"response_time":"$upstream_response_time"}';

            access_log /var/log/nginx/access.log json;

    }

    ...
    ```

1. Mount the Nginx log directory to Beats.
1. Start Beats:
    ```bash
    docker compose up -d beats
    ```
