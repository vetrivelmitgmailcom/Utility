@echo off
title  Tool to Keep Windows Active During Idle Time
powershell -ExecutionPolicy Bypass -File "%~dp0AutoClickWindowBtn.ps1"
pause