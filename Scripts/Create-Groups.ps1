#Requires -Modules ActiveDirectory

[CmdletBinding()]
param()

Import-Module "$PSScriptRoot\..\Modules\H24.ActiveDirectory.psm1" -Force

$ConfigPath = Join-Path $PSScriptRoot "..\Config\Company.json"

if (-not (Test-Path $ConfigPath)) {
    throw "Configuration file not found: $ConfigPath"
}

$Config = Get-Content $ConfigPath -Raw | ConvertFrom-Json

$DomainDN = (Get-ADDomain).DistinguishedName
$GroupsOU = "OU=Groups,$DomainDN"

foreach ($Group in $Config.Groups) {

    try {
    $ADGroup = Get-ADGroup -Identity $Group -ErrorAction Stop
}
catch {
    $ADGroup = $null
}

    if (-not $ADGroup) {

        Write-H24Log "Creating Group: $Group"

        try {

            New-ADGroup `
                -Name $Group `
                -SamAccountName $Group `
                -GroupCategory Security `
                -GroupScope Global `
                -Path $GroupsOU `
                -ErrorAction Stop

            Write-H24Log "Group created: $Group"

        }
        catch {

            Write-H24Log "Failed to create Group: $Group - $($_.Exception.Message)" "ERROR"

        }

    }
    else {

        Write-H24Log "Group already exists: $Group"

    }

}

Write-H24Log "Group deployment completed."