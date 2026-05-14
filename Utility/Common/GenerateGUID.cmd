@echo off
title Generate New GUID
powershell -ExecutionPolicy Bypass -File "%~dp0GenerateGUID.ps1"
pause