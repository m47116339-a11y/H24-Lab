#Requires -Modules ActiveDirectory

[CmdletBinding()]
param()

$ConfigPath = Join-Path $PSScriptRoot "..\Config\Company.json"

if (-not (Test-Path $ConfigPath)) {
    throw "Configuration file not found: $ConfigPath"
}

$config = Get-Content $ConfigPath -Raw | ConvertFrom-Json

$DomainDN = (Get-ADDomain).DistinguishedName

foreach ($OU in $config.OrganizationalUnits) {

    $DN = "OU=$OU,$DomainDN"

    if (-not (Get-ADOrganizationalUnit -LDAPFilter "(ou=$OU)" -ErrorAction SilentlyContinue)) {

        Write-Host "Creating OU: $OU" -ForegroundColor Green

        New-ADOrganizationalUnit `
            -Name $OU `
            -Path $DomainDN `
            -ProtectedFromAccidentalDeletion $true

    }
    else {

        Write-Host "OU already exists: $OU" -ForegroundColor Yellow

    }

}

$EmployeesDN = "OU=Employees,$DomainDN"

foreach ($Department in $config.Departments) {

    if (-not (Get-ADOrganizationalUnit -LDAPFilter "(ou=$Department)" -SearchBase $EmployeesDN -ErrorAction SilentlyContinue)) {

        Write-Host "Creating Department: $Department" -ForegroundColor Cyan

        New-ADOrganizationalUnit `
            -Name $Department `
            -Path $EmployeesDN `
            -ProtectedFromAccidentalDeletion $true

    }
    else {

        Write-Host "Department already exists: $Department" -ForegroundColor Yellow

    }

}

Write-Host ""
Write-Host "Active Directory structure deployment completed." -ForegroundColor 
