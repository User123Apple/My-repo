# RadioZET HLS — Deplexo

Gotowy projekt z właściwym obrazem Radio ZET.

Struktura:
- Dockerfile
- deplexo.yaml
- start.sh
- README.md
- media/IMG_6088.png

Deplexo:
- używa Dockerfile,
- port aplikacji: 8080,
- `start.sh` tworzy HLS w `/live/radiozet.m3u8`.

Nowa wersja skaluje obraz do 640x356, więc wysokość jest parzysta i nie powoduje błędu libx264.

Po wdrożeniu:
`https://TWOJ-ADRES.deplexo.com/live/radiozet.m3u8`

Używaj źródła audio wyłącznie, jeśli masz odpowiednie prawa/zgodę na jego dalsze transmitowanie.
