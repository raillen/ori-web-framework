FROM debian:bookworm-slim

RUN apt-get update \
  && apt-get install -y --no-install-recommends ca-certificates libgcc-s1 \
  && rm -rf /var/lib/apt/lists/* \
  && useradd --system --uid 10001 --home /app --shell /usr/sbin/nologin ori

WORKDIR /app

COPY landing-page /app/landing-page
COPY public /app/public

RUN chmod +x /app/landing-page && chown -R ori:ori /app

USER ori

ENV ORI_HOST=0.0.0.0
ENV PORT=8080
ENV ORI_ENV=production

EXPOSE 8080
CMD ["/app/landing-page"]
