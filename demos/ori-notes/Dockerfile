# Build on host (Linux x86_64), then: fly deploy
#   ori compile main.orl -o ori-notes

FROM debian:bookworm-slim

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
       ca-certificates \
       libgcc-s1 \
  && rm -rf /var/lib/apt/lists/* \
  && useradd --system --uid 10001 --home /app --shell /usr/sbin/nologin ori

WORKDIR /app

COPY ori-notes /app/ori-notes
COPY views /app/views
COPY public /app/public

RUN chmod +x /app/ori-notes \
  && chown -R ori:ori /app

USER ori

ENV ORI_HOST=0.0.0.0
ENV PORT=8080
ENV ORI_ENV=production

EXPOSE 8080

# Fail the container if the binary cannot start (better Fly logs than silent hang)
CMD ["/app/ori-notes"]
