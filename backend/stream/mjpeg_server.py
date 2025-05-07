# scrcpy_server/app.py
import subprocess
import cv2
from fastapi import FastAPI
from fastapi.responses import StreamingResponse
import time

app = FastAPI()

def generate_video():
    # Запускаем scrcpy и захватываем вывод
    process = subprocess.Popen(
        ['scrcpy', '--output-format', 'mjpeg', '--bit-rate', '8M'],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE
    )
    
    while True:
        # Читаем и передаем данные
        frame = process.stdout.read(1024*10)
        if frame:
            yield (b'--frame\r\n'
                   b'Content-Type: image/jpeg\r\n\r\n' + frame + b'\r\n')
        time.sleep(0.1)

@app.get("/video")
def video_feed():
    return StreamingResponse(generate_video(), media_type="multipart/x-mixed-replace; boundary=frame")
