$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$favicon = Get-Content -LiteralPath (Join-Path $root 'favicon.svg') -Raw
$pages = @('index.html', 'explorers.html')

foreach ($page in $pages) {
  $html = Get-Content -LiteralPath (Join-Path $root $page) -Raw
  if ($html -notmatch '<link rel="icon" href="/favicon\.svg" type="image/svg\+xml">') {
    throw "$page should use /favicon.svg as the site icon."
  }
}

if ($favicon -notmatch 'M64 12 24 38v52l40 26 40-26V38L64 12Z') {
  throw 'favicon.svg should use the XYZ365 cube mark.'
}

if ($favicon -match 'c12 17 29 38 29 56') {
  throw 'favicon.svg should not use the old droplet mark.'
}
