@echo off

REM Projeyi web için derle
echo Building Flutter project for web...
flutter build web
IF %ERRORLEVEL% NEQ 0 (
    echo Flutter build failed!
    exit /b %ERRORLEVEL%
)

REM Public klasörünü temizle
echo Cleaning public folder...
rmdir /s /q public
mkdir public
IF %ERRORLEVEL% NEQ 0 (
    echo Cleaning public folder failed!
    exit /b %ERRORLEVEL%
)

REM Derlenmiş dosyaları public klasörüne kopyala
echo Copying built files to public folder...
xcopy build\web\* public /E /H /C /I
IF %ERRORLEVEL% NEQ 0 (
    echo Copying files failed!
    exit /b %ERRORLEVEL%
)

REM Firebase deploy işlemini gerçekleştir
echo Deploying to Firebase Hosting...
firebase deploy --only "hosting"
IF %ERRORLEVEL% NEQ 0 (
    echo Firebase deploy failed!
    exit /b %ERRORLEVEL%
)

echo Deployment completed successfully!
