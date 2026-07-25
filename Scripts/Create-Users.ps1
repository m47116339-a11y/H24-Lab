#Requires -Modules ActiveDirectory

[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [SecureString]$Password
)
Import-Module "$PSScriptRoot\..\Modules\H24.ActiveDirectory.psm1" -Force

$ConfigPath = Join-Path $PSScriptRoot "..\Config\Company.json"
$UsersPath = Join-Path $PSScriptRoot "..\Users\Users.csv"

if (-not (Test-Path $ConfigPath)) {
    throw "Configuration file not found: $ConfigPath"
}

if (-not (Test-Path $UsersPath)) {
    throw "Users file not found: $UsersPath"
}

$config = Get-Content $ConfigPath -Raw | ConvertFrom-Json
$Users = Import-Csv $UsersPath

$DomainDN = (Get-ADDomain).DistinguishedName

foreach ($User in $Users) {

    $UserOU = "OU=$($User.Department),OU=Employees,$DomainDN"

    if (-not (Get-ADUser -LDAPFilter "(sAMAccountName=$($User.Username))" -ErrorAction SilentlyContinue)) {

        Write-H24Log "Creating user: $($User.Username)"

        try {

            New-ADUser `
                -Name "$($User.FirstName) $($User.LastName)" `
                -GivenName $User.FirstName `
                -Surname $User.LastName `
                -SamAccountName $User.Username `
                -UserPrincipalName "$($User.Username)@$($config.Domain)" `
                -Path $UserOU `
                -AccountPassword $Password `
                -Enabled $true `
                -ChangePasswordAtLogon $true

            Write-H24Log "User created: $($User.Username)"

        }
        catch {

            Write-H24Log "Failed to create user: $($User.Username) - $($_.Exception.Message)" "ERROR"

            continue

        }

    }
    else {

        Write-H24Log "User already exists: $($User.Username)"

    }

$ExistingUser = Get-ADUser $User.Username -Properties Enabled

if (-not $ExistingUser.Enabled) {

    try {

        Set-ADAccountPassword `
            -Identity $User.Username `
            -NewPassword $Password `
            -Reset `
            -ErrorAction Stop

        Enable-ADAccount `
            -Identity $User.Username `
            -ErrorAction Stop

        Write-H24Log "Enabled existing user: $($User.Username)"

    }
    catch {

        Write-H24Log "Failed to enable existing user: $($User.Username) - $($_.Exception.Message)" "ERROR"
        continue

    }

}

    $GroupName = "GG_$($User.Department)"

    try {

        if (-not (Get-ADGroupMember $GroupName | Where-Object SamAccountName -eq $User.Username)) {

            Add-ADGroupMember `
                -Identity $GroupName `
                -Members $User.Username

            Write-H24Log "Added $($User.Username) to $GroupName"

        }
        else {

            Write-H24Log "$($User.Username) is already a member of $GroupName"

        }

    }
    catch {

        Write-H24Log "Failed to add $($User.Username) to $GroupName - $($_.Exception.Message)" "ERROR"

    }

}

Write-H24Log "User deployment completed."