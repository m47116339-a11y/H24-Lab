#Requires -Modules ActiveDirectory, GroupPolicy

[CmdletBinding()]
param()

Import-Module "$PSScriptRoot\..\Modules\H24.ActiveDirectory.psm1" -Force

try {
    $CompanyConfig = Get-Content "$PSScriptRoot\..\Config\Company.json" | ConvertFrom-Json
    $GpoConfig = Get-Content "$PSScriptRoot\..\Config\GPO.json" | ConvertFrom-Json

    $DomainDN = (Get-ADDomain).DistinguishedName

    foreach ($Policy in $GpoConfig.Policies) {

        $Gpo = Get-GPO -Name $Policy.Name -ErrorAction SilentlyContinue

        if (-not $Gpo) {
            New-GPO -Name $Policy.Name | Out-Null
            Write-H24Log "Created GPO: $($Policy.Name)"
        }
        else {
            Write-H24Log "GPO already exists: $($Policy.Name)"
        }

        switch ($Policy.Target) {

            "Domain" {
                $Target = $DomainDN
            }

            default {
                $Target = "OU=$($Policy.Target),$DomainDN"
            }
        }

        New-GPLink `
            -Name $Policy.Name `
            -Target $Target `
            -LinkEnabled Yes `
            -ErrorAction SilentlyContinue | Out-Null

        Write-H24Log "Linked GPO '$($Policy.Name)' to '$Target'"
    }

    Write-H24Log "GPO deployment completed."
}
catch {
    Write-H24Log $_.Exception.Message "ERROR"
    throw
}