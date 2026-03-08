FROM redis:7.0-alpine

# システムの更新とタイムゾーン設定
RUN apk update && apk add tzdata
ENV TZ=Asia/Tokyo

# 設定ファイルのコピー
COPY redis.conf /usr/local/etc/redis/redis.conf

# Redis用ディレクトリの作成と権限設定
RUN mkdir -p /data && chown redis:redis /data

USER redis
