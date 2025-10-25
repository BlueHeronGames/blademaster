param (
	[string]$TemplatePath = (Join-Path (Split-Path -Parent $PSScriptRoot) "dungeon-crawler-maker/game_template")
)

$ErrorActionPreference = "Stop"

function Resolve-TemplatePath {
	param ([string]$Path)

	if (-not (Test-Path -Path $Path -PathType Container)) {
		throw "Template path '$Path' does not exist."
	}

	return (Get-Item -LiteralPath $Path).FullName
}

function Copy-SourceFile {
	param (
		[string]$Source,
		[string]$Destination
	)

	if (-not (Test-Path -Path $Source)) {
		throw "Source '$Source' does not exist."
	}

	Copy-Item -LiteralPath $Source -Destination $Destination -Recurse
}

$templateRoot = Resolve-TemplatePath -Path $TemplatePath
$sourceRoot   = $PSScriptRoot

$sourceData   = Join-Path $sourceRoot "game_data.json"
$sourceAssets = Join-Path $sourceRoot "assets"

$destData     = Join-Path $templateRoot "game_data.json"
$destAssets   = Join-Path $templateRoot "assets"

$copiedItems = @()

try {
	Copy-SourceFile -Source $sourceData -Destination $destData
	$copiedItems += $destData

	Copy-SourceFile -Source $sourceAssets -Destination $destAssets
	$copiedItems += $destAssets

	Write-Host "Copied game data and assets into '$templateRoot'."
	Write-Host "Inspect or run your export now."
	Write-Host "Press any key to delete the copied files and exit..." -NoNewline
	[void][System.Console]::ReadKey($true)
}
finally {
	foreach ($item in $copiedItems) {
		if (Test-Path -Path $item) {
			Remove-Item -LiteralPath $item -Recurse -Force
		}
	}

	Write-Host "Cleanup complete."
}
