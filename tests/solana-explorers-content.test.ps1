$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$html = Get-Content -LiteralPath (Join-Path $root 'explorers.html') -Raw

$requiredLinks = @(
  'https://solscan.io/',
  'https://solscan.io/?cluster=testnet',
  'https://solscan.io/?cluster=devnet',
  'https://explorer.solana.com/',
  'https://explorer.solana.com/?cluster=testnet',
  'https://explorer.solana.com/?cluster=devnet'
)

foreach ($link in $requiredLinks) {
  if ($html -notmatch ('href="' + [regex]::Escape($link) + '"')) {
    throw "explorers.html should link to $link."
  }
}

if ($html -notmatch '<span class="explorer-name">Solscan</span>') {
  throw 'explorers.html should retain a dedicated Solscan card.'
}

if ($html -notmatch '<span class="explorer-name">Solana Explorer</span>') {
  throw 'explorers.html should include a dedicated Solana Explorer card.'
}

if ($html -notmatch '<span class="badge">备用</span>') {
  throw 'The Solana Explorer card should be marked as the backup.'
}

if ([regex]::Matches($html, '<span class="explorer-chain">Solana</span>').Count -ne 2) {
  throw 'explorers.html should render Solscan and Solana Explorer as two separate Solana cards.'
}
