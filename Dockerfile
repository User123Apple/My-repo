FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV PORT=8080

RUN apt-get update \
    && apt-get install -y --no-install-recommends ffmpeg python3 ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && useradd -u 1000 -m -d /home/app app

WORKDIR /app

COPY --chown=1000:1000 start.sh /app/start.sh
COPY --chown=1000:1000 media/radiozet.png /app/radiozet.png

RUN chmod +x /app/start.sh \
    && mkdir -p /home/app/data/live \
    && chown -R 1000:1000 /home/app/data

USER 1000:1000

EXPOSE 8080

CMD ["/app/start.sh"]
