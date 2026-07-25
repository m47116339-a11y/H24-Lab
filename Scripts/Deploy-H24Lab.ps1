#Requires -Modules ActiveDirectory

[CmdletBinding()]
param()

Import-Module "$PSScriptRoot\..\Modules\H24.ActiveDirectory.psm1" -Force

Write-H24Log "Starting H24 Lab deployment"

$Password = Read-Host "Enter default user password" -AsSecureString

& "$PSScriptRoot\Create-OUs.ps1"
& "$PSScriptRoot\Create-Groups.ps1"
& "$PSScriptRoot\Create-GPO.ps1"
& "$PSScriptRoot\Create-Users.ps1" -Password $Password

Write-H24Log "H24 Lab deployment completed"