#Requires -Modules ActiveDirectory, GroupPolicy

[CmdletBinding()]
param()

Import-Module "$PSScriptRoot\..\Modules\H24.ActiveDirectory.psm1" -Force

$Config = Get-Content "$PSScriptRoot\..\Config\Company.json" -Raw | ConvertFrom-Json
$GpoConfig = Get-Content "$PSScriptRoot\..\Config\GPO.json" -Raw | ConvertFrom-Json

$DomainDN = (Get-ADDomain).DistinguishedName

$Passed = $true
Write-H24Log "Checking Organizational Units..."

foreach ($OU in $Config.OrganizationalUnits) {

    if (Get-ADOrganizationalUnit -LDAPFilter "(ou=$OU)" -ErrorAction SilentlyContinue) {

        Write-H24Log "PASS - OU exists: $OU"

    }
    else {

        Write-H24Log "FAIL - OU missing: $OU" "ERROR"
        $Passed = $false

    }

}
Write-H24Log "Checking Security Groups..."

foreach ($Group in $Config.Groups) {

    if (Get-ADGroup -Identity $Group -ErrorAction SilentlyContinue) {

        Write-H24Log "PASS - Group exists: $Group"

    }
    else {

        Write-H24Log "FAIL - Group missing: $Group" "ERROR"
        $Passed = $false

    }

}
Write-H24Log "Checking Group Policies..."

foreach ($Policy in $GpoConfig.Policies) {

    if (Get-GPO -Name $Policy.Name -ErrorAction SilentlyContinue) {

        Write-H24Log "PASS - GPO exists: $($Policy.Name)"

    }
    else {

        Write-H24Log "FAIL - GPO missing: $($Policy.Name)" "ERROR"
        $Passed = $false

    }

}
Write-H24Log "Checking Users..."

$Users = Import-Csv "$PSScriptRoot\..\Users\Users.csv"

foreach ($User in $Users) {

    if (Get-ADUser -Identity $User.Username -ErrorAction SilentlyContinue) {

        Write-H24Log "PASS - User exists: $($User.Username)"

    }
    else {

        Write-H24Log "FAIL - User missing: $($User.Username)" "ERROR"
        $Passed = $false

    }

}
Write-H24Log "Checking Group Membership..."

foreach ($User in $Users) {

    $Group = "GG_$($User.Department)"

    $Member = Get-ADGroupMember $Group -Recursive |
        Where-Object SamAccountName -eq $User.Username

    if ($Member) {

        Write-H24Log "PASS - $($User.Username) is a member of $Group"

    }
    else {

        Write-H24Log "FAIL - $($User.Username) is NOT a member of $Group" "ERROR"
        $Passed = $false

    }

}
Write-Host ""
Write-Host "========================================="

if ($Passed) {

    Write-H24Log "Lab validation completed successfully."

}
else {

    Write-H24Log "Lab validation failed." "ERROR"

}

Write-Host "========================================="