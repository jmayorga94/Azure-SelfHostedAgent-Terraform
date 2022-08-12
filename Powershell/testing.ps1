[CmdletBinding()]
param (
   [Parameter(ValuefromPipeline=$true,Mandatory=$true)] [string]$AZP_URL)


   Write-Host $AZP_URL

   return $AZP_URL