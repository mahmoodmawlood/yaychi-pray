@echo off
echo Adding Service Worker registration fix...
echo. >> build\web\flutter.js
echo if ('serviceWorker' in navigator) { >> build\web\flutter.js
echo   window.addEventListener('load', function () { >> build\web\flutter.js
echo     navigator.serviceWorker.register('/my_web_app/flutter_service_worker.js', { scope: '/my_web_app/' }); >> build\web\flutter.js
echo   }); >> build\web\flutter.js
echo } >> build\web\flutter.js
