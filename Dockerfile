FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends ffmpeg python3 ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && useradd -u 1000 -m -d /home/app app

WORKDIR /app

COPY --chown=1000:1000 start.sh /app/start.sh
COPY --chown=1000:1000 media/IMG_6088.png /app/IMG_6088.png

RUN chmod +x /app/start.sh && mkdir -p /home/app/data/live

USER 1000:1000

EXPOSE 8080

CMD ["/app/start.sh"]
