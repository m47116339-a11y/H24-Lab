function Write-H24Log {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Message,

        [ValidateSet("INFO","WARNING","ERROR")]
        [string]$Level = "INFO"
    )

    $Time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    switch ($Level) {
        "INFO"    { $Color = "Green" }
        "WARNING" { $Color = "Yellow" }
        "ERROR"   { $Color = "Red" }
    }

    Write-Host "[$Time] [$Level] $Message" -ForegroundColor $Color

    $LogPath = Join-Path $PSScriptRoot "..\Logs\Deploy.log"
    $LogDirectory = Split-Path $LogPath

    if (-not (Test-Path $LogDirectory)) {
        New-Item `
            -ItemType Directory `
            -Path $LogDirectory `
            -Force | Out-Null
    }

    Add-Content -Path $LogPath -Value "[$Time] [$Level] $Message"
}

Export-ModuleMember -Function Write-H24Log