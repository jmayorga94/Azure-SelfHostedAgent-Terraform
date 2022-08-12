[CmdletBinding()]
param (
   [Parameter(ValuefromPipeline=$true,Mandatory=$true)] [string]$AZP_URL,
   [Parameter(ValuefromPipeline=$true,Mandatory=$true)] [string]$AZP_TOKEN,
   [Parameter(ValuefromPipeline=$true,Mandatory=$true)] [string]$AZP_AGENT_NAME,
   [Parameter(ValuefromPipeline=$true,Mandatory=$true)] [string]$AZP_POOL)

$registerAgentScriptURL="https://github.com/jmayorga94/Powershell-Scripts.git" #contains the script for registering an agent

Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

Write-Host "1. Upgrading choco " 
#Upgrading choco
choco upgrade chocolatey -y

Write-Host "2. Installing Git " 

# Install Git
choco install -y git 

Write-Host "3. Refreshing environment variables for Git " 

$env:ChocolateyInstall = Convert-Path "$((Get-Command choco).Path)\..\.."   
Import-Module "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"

refreshenv

# Verify that git can be called.
git --version

#Clone repo to specific path
Write-Host "4. Cloning Repo " 

git clone $registerAgentScriptURL "C:/tmp/azp/"

Write-Host "5. Run DevopsAgentSetup Agent " 

Set-Location "C:/tmp/azp/"

powershell -ExecutionPolicy Unrestricted -File ./DevopsAgentSetup.ps1 -AZP_URL $AZP_URL  -AZP_TOKEN $AZP_TOKEN  -AZP_AGENT_NAME $AZP_AGENT_NAME   -AZP_POOL $AZP_POOL
