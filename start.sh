#!/bin/sh
set -eu

mkdir -p /home/app/data/live

ffmpeg -hide_banner -loglevel warning \
  -re -loop 1 -i /app/IMG_6088.png \
  -i "https://n-11-29.dcs.redcdn.pl/sc/o2/Eurozet/live/audio.livx?audio=5" \
  -map 0:v:0 -map 1:a:0 \
  -c:v libx264 -preset veryfast -tune stillimage \
  -pix_fmt yuv420p -r 25 -g 50 \
  -c:a aac -b:a 128k -ar 44100 \
  -f hls \
  -hls_time 4 \
  -hls_list_size 6 \
  -hls_flags delete_segments+append_list+independent_segments \
  /home/app/data/live/radiozet.m3u8 &

exec python3 -u - <<'PY'
import http.server, os

ROOT = "/home/app/data"
PORT = int(os.environ.get("PORT", "8080"))

class Handler(http.server.SimpleHTTPRequestHandler):
    extensions_map = {
        **http.server.SimpleHTTPRequestHandler.extensions_map,
        ".m3u8": "application/vnd.apple.mpegurl",
        ".ts": "video/mp2t",
    }

    def end_headers(self):
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Cache-Control", "no-cache, no-store, must-revalidate")
        super().end_headers()

    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=ROOT, **kwargs)

    def log_message(self, fmt, *args):
        pass

server = http.server.ThreadingHTTPServer(("0.0.0.0", PORT), Handler)
server.serve_forever()
PY
