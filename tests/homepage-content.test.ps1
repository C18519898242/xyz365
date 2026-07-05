$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$html = Get-Content -LiteralPath (Join-Path $root 'index.html') -Raw

if ($html -match '<section\s+class="resource-lane"') {
  throw 'Homepage should not render the future resources lane.'
}

if ($html -notmatch '<a href="https://www\.xyz365\.tech/" target="_blank" rel="noopener">www\.xyz365\.tech</a>') {
  throw 'Footer should link to and display www.xyz365.tech.'
}
