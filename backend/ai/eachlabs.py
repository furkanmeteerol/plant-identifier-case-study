import base64
import json

import httpx
from pydantic import ValidationError

from config import settings
from models import PlantResult


class AIServiceError(Exception):
    """Raised when the AI provider cannot process a request."""


def identify_plant(image_data: bytes, mime_type: str):
    api_key = settings.eachlabs_api_key

    image_base64 = base64.b64encode(image_data).decode("utf-8")

    prompt = """
    Identify the plant in the image.

    If the image does not contain a plant:
    - set is_plant to false
    - set plant_name to null
    - set scientific_name to null
    - set confidence to 0
    - briefly state that no plant was detected
    - do not identify or describe other objects in the image

    If a plant is present:
    - identify it as accurately as possible
    - provide the common name
    - provide the scientific name
    - give a confidence score between 0 and 1
    - provide a short description

    Return ONLY valid JSON with exactly these fields:
    {
      "is_plant": true,
      "plant_name": "Common name",
      "scientific_name": "Scientific name",
      "confidence": 0.0,
      "description": "Short description"
    }
    """

    payload = {
        "model": "google/gemini-3.7-flash",
        "messages": [
            {
                "role": "user",
                "content": [
                    {
                        "type": "text",
                        "text": prompt,
                    },
                    {
                        "type": "image_url",
                        "image_url": {
                            "url": f"data:{mime_type};base64,{image_base64}"
                        },
                    },
                ],
            }
        ],
        "max_tokens": 500,
    }

    try:
        response = httpx.post(
            "https://api.eachlabs.ai/v1/chat/completions",
            headers={
                "Authorization": f"Bearer {api_key}",
                "Content-Type": "application/json",
            },
            json=payload,
            timeout=30.0,
        )

        response.raise_for_status()

    except httpx.TimeoutException as exc:
        raise AIServiceError(
            "AI provider request timed out."
        ) from exc

    except httpx.HTTPStatusError as exc:
        raise AIServiceError(
            f"AI provider returned HTTP {exc.response.status_code}."
        ) from exc

    except httpx.RequestError as exc:
        raise AIServiceError(
            "Could not connect to AI provider."
        ) from exc

    try:
        result = response.json()
    except json.JSONDecodeError as exc:
        raise AIServiceError(
            "AI provider returned an invalid JSON response."
        ) from exc

    try:
        content = result["choices"][0]["message"]["content"].strip()

        if content.startswith("```"):
            content = content.split("\n", 1)[1]
            content = content.rsplit("```", 1)[0].strip()

        parsed = json.loads(content)

        return PlantResult.model_validate(parsed)

    except (
        KeyError,
        IndexError,
        TypeError,
        json.JSONDecodeError,
        ValidationError,
    ) as exc:
        raise AIServiceError(
            "AI provider returned an invalid plant identification response."
        ) from exc