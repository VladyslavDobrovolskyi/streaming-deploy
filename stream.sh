#!/bin/bash

VIDEO_PATH="video.mp4"
STREAM_PATH="./stream"

if ! command -v ffmpeg &> /dev/null; then
    echo "❌ FFmpeg не установлен. Установите его с помощью 'sudo apt install ffmpeg'."
    exit 1
fi

if [ ! -f "$VIDEO_PATH" ]; then
    echo "❌ Видео не найдено по пути: $VIDEO_PATH"
    exit 1
fi

mkdir -p "$STREAM_PATH"
rm -rf "$STREAM_PATH"/*

echo "🚀 Запуск низкозадержного HLS потока..."

ffmpeg -re -stream_loop -1 -i "$VIDEO_PATH" \
  -c:v libx264 -preset veryfast -crf 23 \
  -c:a aac -b:a 128k -f hls \
  -hls_time 3 -hls_list_size 2 \
  -hls_flags delete_segments+omit_endlist+program_date_time \
  -hls_allow_cache 0 \
  "$STREAM_PATH/playlist.m3u8"
