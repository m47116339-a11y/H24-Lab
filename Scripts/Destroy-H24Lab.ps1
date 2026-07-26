#Requires -Modules ActiveDirectory, GroupPolicy

[CmdletBinding(
    SupportsShouldProcess = $true,
    ConfirmImpact = 'High'
)]
param()

Import-Module "$PSScriptRoot\..\Modules\H24.ActiveDirectory.psm1" -Force

$Config = Get-Content "$PSScriptRoot\..\Config\Company.json" -Raw | ConvertFrom-Json
$GpoConfig = Get-Content "$PSScriptRoot\..\Config\GPO.json" -Raw | ConvertFrom-Json
$Users = Import-Csv "$PSScriptRoot\..\Users\Users.csv"

$DomainDN = (Get-ADDomain).DistinguishedName

Write-H24Log "Starting H24 Lab cleanup"

# --------------------------------------------------------------------
# Remove Users
# --------------------------------------------------------------------

Write-H24Log "Removing users..."

foreach ($User in $Users) {

    $ADUser = Get-ADUser -Identity $User.Username -ErrorAction SilentlyContinue

    if (-not $ADUser) {
        Write-H24Log "User not found: $($User.Username)"
        continue
    }

    if ($PSCmdlet.ShouldProcess($User.Username, "Remove AD User")) {

        try {

            Remove-ADUser -Identity $ADUser -Confirm:$false -ErrorAction Stop
            Write-H24Log "Removed user: $($User.Username)"

        }
        catch {

            Write-H24Log "Failed to remove user: $($User.Username). $_" "ERROR"

        }
    }
}

# --------------------------------------------------------------------
# Remove Security Groups
# --------------------------------------------------------------------

Write-H24Log "Removing security groups..."

foreach ($Group in $Config.Groups) {

    $ADGroup = Get-ADGroup -Identity $Group -ErrorAction SilentlyContinue

    if (-not $ADGroup) {
        Write-H24Log "Group not found: $Group"
        continue
    }

    if ($PSCmdlet.ShouldProcess($Group, "Remove AD Group")) {

        try {

            Remove-ADGroup -Identity $ADGroup -Confirm:$false -ErrorAction Stop
            Write-H24Log "Removed group: $Group"

        }
        catch {

            Write-H24Log "Failed to remove group: $Group. $_" "ERROR"

        }
    }
}

# --------------------------------------------------------------------
# Remove GPOs
# --------------------------------------------------------------------

Write-H24Log "Removing Group Policies..."

foreach ($Policy in $GpoConfig.Policies) {

    $GPO = Get-GPO -Name $Policy.Name -ErrorAction SilentlyContinue

    if (-not $GPO) {
        Write-H24Log "GPO not found: $($Policy.Name)"
        continue
    }

    if ($PSCmdlet.ShouldProcess($Policy.Name, "Remove GPO")) {

        try {

            Remove-GPO -Name $Policy.Name -ErrorAction Stop
            Write-H24Log "Removed GPO: $($Policy.Name)"

        }
        catch {

            Write-H24Log "Failed to remove GPO: $($Policy.Name). $_" "ERROR"

        }
    }
}

# --------------------------------------------------------------------
# Remove Organizational Units
# --------------------------------------------------------------------

Write-H24Log "Removing Organizational Units..."

$OUs = $Config.OrganizationalUnits | Sort-Object -Descending

foreach ($OU in $OUs) {

    $OUdn = "OU=$OU,$DomainDN"

    $ADOU = Get-ADOrganizationalUnit -Identity $OUdn -ErrorAction SilentlyContinue

    if (-not $ADOU) {
        Write-H24Log "OU not found: $OU"
        continue
    }

    if ($PSCmdlet.ShouldProcess($OU, "Remove Organizational Unit")) {

        try {

            Set-ADOrganizationalUnit `
                -Identity $OUdn `
                -ProtectedFromAccidentalDeletion $false `
                -ErrorAction Stop

            Remove-ADOrganizationalUnit `
                -Identity $OUdn `
                -Recursive `
                -Confirm:$false `
                -ErrorAction Stop

            Write-H24Log "Removed OU: $OU"

        }
        catch {

            Write-H24Log "Failed to remove OU: $OU. $($_.Exception.Message)" "ERROR"

        }

    }

}

Write-H24Log "H24 Lab cleanup completed"