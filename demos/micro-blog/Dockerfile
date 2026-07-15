# Build on host (Linux x86_64 + glibc ≥ 2.39):
#   ORI_USE_AOT=1 ori compile main.orl -o micro-blog
#   fly deploy --ha=false

FROM ubuntu:24.04

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
       ca-certificates \
       libgcc-s1 \
  && rm -rf /var/lib/apt/lists/* \
  && useradd --system --uid 10001 --home /app --shell /usr/sbin/nologin ori \
  && mkdir -p /data \
  && chown ori:ori /data

WORKDIR /app

COPY micro-blog /app/micro-blog
COPY views /app/views
COPY public /app/public
COPY entrypoint.sh /app/entrypoint.sh

RUN chmod +x /app/micro-blog /app/entrypoint.sh \
  && chown -R ori:ori /app

ENV ORI_HOST=0.0.0.0
ENV PORT=8080
ENV ORI_ENV=production
ENV MICROBLOG_DB=/data/microblog.db
ENV MICROBLOG_SESSION_DB=/data/microblog_sessions.db

EXPOSE 8080

# entrypoint fixes /data ownership then drops privileges
USER root
ENTRYPOINT ["/app/entrypoint.sh"]
