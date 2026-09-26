#!/bin/sh
set -eu

PORT="${PORT:-8080}"
OUT="/home/app/data"
LIVE="$OUT/live"
mkdir -p "$LIVE"

AUDIO_URL='https://n-11-29.dcs.redcdn.pl/sc/o2/Eurozet/live/audio.livx?audio=5'

rm -f "$LIVE"/radiozet.m3u8 "$LIVE"/radiozet*.ts

ffmpeg \
  -hide_banner \
  -loglevel warning \
  -nostdin \
  -reconnect 1 \
  -reconnect_streamed 1 \
  -reconnect_delay_max 10 \
  -rw_timeout 15000000 \
  -loop 1 \
  -framerate 1 \
  -i /app/radiozet.png \
  -i "$AUDIO_URL" \
  -map 0:v:0 \
  -map 1:a:0 \
  -vf "scale=640:-2:flags=fast_bilinear" \
  -c:v libx264 \
  -preset ultrafast \
  -tune stillimage \
  -pix_fmt yuv420p \
  -r 1 \
  -g 2 \
  -keyint_min 2 \
  -threads 1 \
  -b:v 80k \
  -maxrate 80k \
  -bufsize 160k \
  -c:a aac \
  -b:a 64k \
  -ar 44100 \
  -ac 2 \
  -f hls \
  -hls_time 4 \
  -hls_list_size 6 \
  -hls_flags delete_segments+append_list+independent_segments \
  -hls_segment_filename "$LIVE/radiozet%03d.ts" \
  "$LIVE/radiozet.m3u8" &
FFMPEG_PID=$!

cleanup() {
  kill "$FFMPEG_PID" 2>/dev/null || true
  wait "$FFMPEG_PID" 2>/dev/null || true
}
trap cleanup INT TERM EXIT

cd "$OUT"
exec python3 - "$PORT" <<'PY'
import http.server
import sys

port = int(sys.argv[1])

class Handler(http.server.SimpleHTTPRequestHandler):
    extensions_map = {
        **http.server.SimpleHTTPRequestHandler.extensions_map,
        ".m3u8": "application/vnd.apple.mpegurl",
        ".ts": "video/mp2t",
    }

    def end_headers(self):
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Cache-Control", "no-store, no-cache, must-revalidate")
        super().end_headers()

    def log_message(self, fmt, *args):
        pass

http.server.ThreadingHTTPServer(("0.0.0.0", port), Handler).serve_forever()
PY
