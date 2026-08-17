@echo off
echo ============================================
echo   TreeCut Organizer (Run as Administrator!)
echo ============================================
echo.
echo Organizing TreeCut files to E:\TreeCut_Organized
echo Same-drive moves are instant; G drive 7.2GB copy takes a few minutes.
echo DO NOT close this window until it says DONE.
echo.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0organize_treecut.ps1"
echo.
echo ===== DONE =====
echo Files are organized to E:\TreeCut_Organized
echo Log: E:\TreeCut_Organized\_organize_log.txt
echo.
pause