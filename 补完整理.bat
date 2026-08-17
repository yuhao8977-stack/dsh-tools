@echo off
echo ============================================
echo   TreeCut Organizer - Final Pass
echo ============================================
echo Finishing remaining steps (G drive 7.2GB copy takes a few minutes)...
echo DO NOT close this window.
echo.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0finish_treecut.ps1"
echo.
echo ===== DONE =====
pause