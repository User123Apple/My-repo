# RadioZET HLS — Deplexo

Gotowy projekt dla Deplexo. FFmpeg łączy obraz PNG ze źródłem audio i tworzy playlistę HLS.

## Struktura

- Dockerfile
- start.sh
- README.md
- media/IMG_6109.png

## Po wdrożeniu

Playlistę HLS znajdziesz pod:

`https://TWOJ-ADRES.deplexo.com/live/radiozet.m3u8`

## Zmiana względem poprzedniej wersji

Obraz 1050x585 miał nieparzystą wysokość. Nowa wersja skaluje go do 640x356, więc wymiary są poprawne dla H.264. Dodatkowo ustawiono lekkie parametry kodowania, aby zmniejszyć obciążenie darmowego kontenera.

Używaj podanego źródła audio tylko wtedy, gdy masz odpowiednie prawa/zgodę na jego dalsze transmitowanie.
