# Host binary is often linked against a recent glibc (e.g. Ubuntu 24.04 → GLIBC_2.39).
# debian:bookworm only has ~2.36 → crash: "GLIBC_2.39 not found".
# Use Ubuntu 24.04 so host-built Ori binaries run on Fly.
#
#   ori compile main.orl -o ori-notes
#   fly deploy --ha=false

FROM ubuntu:24.04

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

CMD ["/app/ori-notes"]
