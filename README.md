# Plant Identifier

An AI-powered Flutter mobile application that identifies plants from photos.

This project was created as part of an AI Engineer case study.

## What It Does

Plant Identifier lets users:

- Take a photo of a plant
- Choose an existing photo from the gallery
- Crop the image before identification
- Identify the plant using an AI model
- View the common name and scientific name
- View a confidence score and short description
- Handle non-plant images gracefully

The application sends the processed image to a FastAPI backend, which communicates with the EachLabs API using Gemini 3.7 Flash.

## Tech Stack

### Mobile

- Flutter
- Dart
- `image_picker`
- `image_cropper_widget`
- `image`
- `http`
- Material 3

### Backend

- Python
- FastAPI
- Uvicorn
- Pydantic
- httpx

### AI

- EachLabs API
- Google Gemini 3.7 Flash

## Project Structure

```text
plant-identifier/
├── backend/
│   ├── ai/
│   │   └── eachlabs.py
│   ├── config.py
│   ├── main.py
│   └── models.py
│
├── mobile/
│   ├── lib/
│   │   ├── models/
│   │   ├── pages/
│   │   ├── services/
│   │   ├── theme/
│   │   ├── widgets/
│   │   └── config.dart
│   ├── android/
│   ├── ios/
│   ├── assets/
│   └── pubspec.yaml
│
├── requirements.txt
└── .gitignore
```

## How It Works

```text
Photo / Gallery
      ↓
Crop
      ↓
Image Resize & Compression
      ↓
Flutter HTTP Request
      ↓
FastAPI Backend
      ↓
EachLabs API
      ↓
Gemini 3.7 Flash
      ↓
Structured PlantResult
      ↓
Flutter Result Screen
```

## Image Processing

Before sending an image to the backend, the Flutter app processes large images on the device.

- Maximum dimension: 1024 px
- JPEG quality: 85
- Large images are resized before upload

This reduces the amount of data sent to the backend while keeping enough image detail for identification.

## Backend API

### Health Check

```http
GET /health
```

Returns:

```json
{
  "status": "ok"
}
```

### Plant Identification

```http
POST /identify
```

The endpoint accepts a multipart image upload.

Supported image types:

- JPEG
- PNG
- WebP

Maximum upload size:

- 10 MB

The API returns a structured response containing the plant identification, confidence score, and description.

For non-plant images, the backend returns a response with `is_plant: false`.

## Backend Setup

### 1. Create a virtual environment

From the project root:

```powershell
cd backend
python -m venv .venv
```

### 2. Activate the virtual environment

Windows PowerShell:

```powershell
.\.venv\Scripts\Activate.ps1
```

### 3. Install dependencies

```powershell
cd ..
pip install -r requirements.txt
```

### 4. Configure the API key

Create:

```text
backend/.env
```

Add your own EachLabs API key:

```env
EACHLABS_API_KEY=your_api_key_here
```

Do not commit the `.env` file.

### 5. Start the backend

From the project root:

```powershell
cd backend
uvicorn main:app --reload
```

The API will be available at:

```text
http://127.0.0.1:8000
```

You can check it with:

```text
http://127.0.0.1:8000/health
```

## Flutter Setup

Make sure Flutter and an Android emulator are installed.

From the project root:

```powershell
cd mobile
flutter pub get
```

The Android application is configured to use:

```text
http://10.0.2.2:8000
```

`10.0.2.2` maps to the host machine from an Android Emulator.

Start an Android Emulator and run:

```powershell
flutter run
```

## Running the Complete Application

### Terminal 1 — Backend

```powershell
cd C:\Projects\plant-identifier\backend
.\.venv\Scripts\Activate.ps1
uvicorn main:app --reload
```

### Terminal 2 — Flutter

```powershell
cd C:\Projects\plant-identifier\mobile
flutter pub get
flutter run
```

The Android emulator must be running before starting the Flutter application.

## Error Handling

The application handles several failure cases:

- No plant detected
- Backend unavailable
- AI provider unavailable
- Request timeout
- Invalid image response
- Unsupported image type
- Image larger than 10 MB

The user receives a simple error message instead of a raw exception.

## Permissions

### Android

The Android application includes the required Internet permission for communication with the backend.

### iOS

The iOS application includes usage descriptions for:

- Camera access
- Photo library access

## Notes

This project was developed as a focused case-study implementation. The core product flow is intentionally kept simple:

**Select / Take Photo → Crop → Identify → Result**
