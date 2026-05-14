@echo off
title  Tool to Get Values from Keyvault
powershell -ExecutionPolicy Bypass -File "%~dp0GetAllSecretsFromKeyvault.ps1"
pause