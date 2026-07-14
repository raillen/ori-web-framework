# Build the Linux binary on the host (or CI) first:
#   ori compile main.orl -o ori-notes
# then: fly deploy

FROM debian:bookworm-slim

RUN apt-get update \
  && apt-get install -y --no-install-recommends ca-certificates \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY ori-notes /app/ori-notes
COPY views /app/views
COPY public /app/public

RUN chmod +x /app/ori-notes

ENV ORI_HOST=0.0.0.0
ENV PORT=8080

EXPOSE 8080

CMD ["/app/ori-notes"]
