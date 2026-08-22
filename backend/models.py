from pydantic import BaseModel, Field


class PlantResult(BaseModel):
    is_plant: bool
    plant_name: str | None = None
    scientific_name: str | None = None
    confidence: float = Field(ge=0, le=1)
    description: str