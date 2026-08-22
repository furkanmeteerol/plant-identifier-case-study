import logging

from fastapi import FastAPI, File, UploadFile, HTTPException

from ai.eachlabs import AIServiceError, identify_plant
from models import PlantResult


app = FastAPI(
    title="Plant Identifier API",
    description="AI-powered plant identification service.",
    version="1.0.0",
)

logger = logging.getLogger(__name__)


@app.get(
    "/health",
    tags=["Health"],
    summary="Check API health",
)
async def health():
    return {"status": "ok"}


ALLOWED_IMAGE_TYPES = {
    "image/jpeg",
    "image/png",
    "image/webp",
}

MAX_IMAGE_SIZE = 10 * 1024 * 1024


@app.post(
    "/identify",
    response_model=PlantResult,
    tags=["Plant Identification"],
    summary="Identify a plant from an image",
)
async def identify(image: UploadFile = File(...)):
    if image.content_type not in ALLOWED_IMAGE_TYPES:
        raise HTTPException(
            status_code=400,
            detail="Only JPEG, PNG, and WebP images are supported.",
        )

    image_data = await image.read()

    if not image_data:
        raise HTTPException(
            status_code=400,
            detail="The uploaded image is empty.",
        )

    if len(image_data) > MAX_IMAGE_SIZE:
        raise HTTPException(
            status_code=400,
            detail="The uploaded image is too large. Maximum size is 10 MB.",
        )

    try:
        result = identify_plant(
            image_data,
            image.content_type,
        )
    except AIServiceError as exc:
        logger.error("AI service error: %s", exc)

        raise HTTPException(
            status_code=503,
            detail="The plant identification service is temporarily unavailable.",
        )

    return result