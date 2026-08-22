$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$html = Get-Content -LiteralPath (Join-Path $root 'explorers.html') -Raw

$removedContent = @(
  'aria-labelledby="xyz-title"',
  '>XYZ365 服务</h2>',
  '>XYZ365 Explorer</span>',
  '>Anvil Sepolia Fork</span>'
)

foreach ($content in $removedContent) {
  if ($html.Contains($content)) {
    throw "explorers.html should not contain the removed XYZ365 Explorer section: $content"
  }
}
