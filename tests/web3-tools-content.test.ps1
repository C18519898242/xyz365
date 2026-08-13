$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$html = Get-Content -LiteralPath (Join-Path $root 'tools.html') -Raw
$groupIds = @('asset-tools-title', 'network-tools-title', 'creation-tools-title')
$links = @(
  'https://app.zerion.io/',
  'https://app.hyperliquid.xyz/trade',
  'https://app.ondo.finance/',
  'https://coinmarketcap.com/',
  'https://chainlist.org/',
  'https://www.plasma.to/zh',
  'https://www.stable.xyz/',
  'https://blockstream.com/',
  'https://20lab.app/'
)

foreach ($groupId in $groupIds) {
  if ($html -notmatch ('id="' + $groupId + '"')) {
    throw "tools.html should include the $groupId group."
  }
}

foreach ($link in $links) {
  $pattern = '<a class="tool-link" href="' + [regex]::Escape($link) + '" target="_blank" rel="noopener">'
  if ($html -notmatch $pattern) {
    throw "tools.html should safely link to $link."
  }
}

if ([regex]::Matches($html, '<a class="tool-link" ').Count -ne 9) {
  throw 'tools.html should contain exactly nine tool links.'
}

if ($html -notmatch '<strong>9</strong>') {
  throw 'tools.html should show a nine-tool summary.'
}
