#Requires -Modules ActiveDirectory

[CmdletBinding()]
param()
Import-Module "$PSScriptRoot\..\Modules\H24.ActiveDirectory.psm1" -Force

$ConfigPath = Join-Path $PSScriptRoot "..\Config\Company.json"

if (-not (Test-Path $ConfigPath)) {
    throw "Configuration file not found: $ConfigPath"
}

$config = Get-Content $ConfigPath -Raw | ConvertFrom-Json

$DomainDN = (Get-ADDomain).DistinguishedName

foreach ($OU in $config.OrganizationalUnits) {

    $DN = "OU=$OU,$DomainDN"

    if (-not (Get-ADOrganizationalUnit -LDAPFilter "(ou=$OU)" -ErrorAction SilentlyContinue)) {

        Write-H24Log "Creating OU: $OU"

        try {

    New-ADOrganizationalUnit `
        -Name $OU `
        -Path $DomainDN `
        -ProtectedFromAccidentalDeletion $true

    Write-H24Log "OU created: $OU"

}
catch {

    Write-H24Log "Failed to create OU: $OU - $($_.Exception.Message)" "ERROR"

}

    }
    else {

        Write-H24Log "OU already exists: $OU"

    }

}

$EmployeesDN = "OU=Employees,$DomainDN"

foreach ($Department in $config.Departments) {

    if (-not (Get-ADOrganizationalUnit -LDAPFilter "(ou=$Department)" -SearchBase $EmployeesDN -ErrorAction SilentlyContinue)) {

        Write-H24Log "Creating Department: $Department"

try {

    New-ADOrganizationalUnit `
        -Name $Department `
        -Path $EmployeesDN `
        -ProtectedFromAccidentalDeletion $true

    Write-H24Log "Department created: $Department"

}
catch {

    Write-H24Log "Failed to create Department: $Department - $($_.Exception.Message)" "ERROR"

}

    }
    else {

        Write-H24Log "Department already exists: $Department"

    }

}

Write-H24Log "Active Directory structure deployment completed."