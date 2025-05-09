#   ---------------------------------------------------------------------------------
#   Copyright (c) Microsoft Corporation. All rights reserved.
#   Licensed under the MIT License. See LICENSE in project root for information.
#   ---------------------------------------------------------------------------------
"""FastAPI application for the video API service."""
#   ---------------------------------------------------------------------------------

__author__ = "Carlos Alejandro Perez Garcia"
__copyright__ = "Copyright 2025"
__license__ = "MIT"
__version__ = "1.0.0"
__maintainer__ = "Carlos Alejandro Perez Garcia"
__email__ = "cpgarcia518@gmail.com"

# Libraries
# ==============================================================================
from fastapi import FastAPI
from minio import Minio
from datetime import datetime
import os

app = FastAPI()

minio = Minio(
    os.getenv("MINIO_ENDPOINT", "minio:9000"),
    access_key=os.getenv("MINIO_ACCESS_KEY"),
    secret_key=os.getenv("MINIO_SECRET_KEY"),
    secure=False,
)


@app.get("/video_url")
async def get_video(from_time: int):
    video_name = (
        datetime.fromtimestamp(from_time / 1000).strftime("%Y%m%d-%H%M%S") + ".mp4"
    )
    url = minio.presigned_get_object("videos", video_name, expires=3600)
    return {"url": url}
