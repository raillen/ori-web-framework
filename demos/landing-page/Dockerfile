# Pre-build on host/CI:
#   cd frontend && npm ci && npm run build
#   ori compile main.orl -o landing-page
# then: fly deploy

FROM debian:bookworm-slim

RUN apt-get update \
  && apt-get install -y --no-install-recommends ca-certificates \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY landing-page /app/landing-page
COPY public /app/public

RUN chmod +x /app/landing-page

ENV ORI_HOST=0.0.0.0
ENV PORT=8080

EXPOSE 8080

CMD ["/app/landing-page"]
