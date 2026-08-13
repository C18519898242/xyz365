# Web3 Tools Directory Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Expand `tools.html` into a nine-item personal Web3 navigation directory grouped by common use case.

**Architecture:** Preserve the static single-page design. Replace the one existing grid with three semantic sections that reuse its card and responsive-grid CSS, and add a PowerShell test that fixes the groups, tool count, URLs, and external-link safety attributes.

**Tech Stack:** Static HTML/CSS; PowerShell tests.

## Global Constraints

- Only `tools.html` changes; add one focused test under `tests/`.
- Preserve existing header, footer, visual language, and mobile behavior.
- Add no JavaScript, external dependencies, or external icons.
- Every tool link uses `target="_blank" rel="noopener"`.
- Retain CoinMarketCap: final page has exactly 9 tool links in 3 categories.

---

### Task 1: Define the directory contract

**Files:**
- Create: `tests/web3-tools-content.test.ps1`
- Modify: none
- Test: `tests/web3-tools-content.test.ps1`

**Interfaces:**
- Consumes: `tools.html` as a UTF-8 static page.
- Produces: a test that fails for a missing group, wrong URL, unsafe external anchor, or tool count other than nine.

- [ ] **Step 1: Write the failing test**

```powershell
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$html = Get-Content -LiteralPath (Join-Path $root 'tools.html') -Raw
$groups = @('资产管理与交易', '网络与基础设施', '创建工具')
$links = @('https://app.zerion.io/', 'https://app.hyperliquid.xyz/trade', 'https://app.ondo.finance/', 'https://coinmarketcap.com/', 'https://chainlist.org/', 'https://www.plasma.to/zh', 'https://www.stable.xyz/', 'https://blockstream.com/', 'https://20lab.app/')
foreach ($group in $groups) { if ($html -notmatch [regex]::Escape($group)) { throw "Missing group: $group" } }
foreach ($link in $links) { if ($html -notmatch ('<a class="tool-link" href="' + [regex]::Escape($link) + '" target="_blank" rel="noopener">')) { throw "Missing safe link: $link" } }
if ([regex]::Matches($html, '<a class="tool-link" ').Count -ne 9) { throw 'Expected nine tool links.' }
if ($html -notmatch '<strong>9</strong>') { throw 'Expected nine-tool summary.' }
```

- [ ] **Step 2: Run the test and verify failure**

Run: `powershell -ExecutionPolicy Bypass -File tests/web3-tools-content.test.ps1`

Expected: failure because the current page has no `资产管理与交易` group and only three tool links.

### Task 2: Implement the grouped directory

**Files:**
- Create: none
- Modify: `tools.html:383-465`
- Test: `tests/web3-tools-content.test.ps1`

**Interfaces:**
- Consumes: the three labels and nine URLs from Task 1.
- Produces: three `.section` groups with exactly nine `.tool-link` anchors.

- [ ] **Step 1: Update hero content**

Use this exact hero copy, retaining the surrounding markup:

```html
<span class="kicker">Personal Web3</span>
<h1>个人 Web3 常用导航</h1>
<p class="lead">集中收藏资产管理、交易、链配置和基础设施服务，按使用场景快速进入常用 Web3 平台。</p>
```

Set summary rows to `收录工具 / 9`, `覆盖分类 / 资产 · 网络 · 创建`, and `使用方式 / 直接跳转`.

- [ ] **Step 2: Replace the old grid with three groups**

Use current card classes for three titled sections: `资产管理与交易` contains Zerion, Hyperliquid, Ondo, CoinMarketCap; `网络与基础设施` contains Chainlist, Plasma, Stable, Blockstream; `创建工具` contains 20Lab. Every card uses a concise Chinese personal-use description and this exact anchor structure with its assigned URL:

```html
<a class="tool-link" href="https://app.zerion.io/" target="_blank" rel="noopener">
  <span class="link-url">zerion.io</span>
  <span class="link-arrow">→</span>
</a>
```

- [ ] **Step 3: Verify focused test**

Run: `powershell -ExecutionPolicy Bypass -File tests/web3-tools-content.test.ps1`

Expected: no output and exit code `0`.

- [ ] **Step 4: Verify all repository tests**

Run: `Get-ChildItem tests -Filter '*.test.ps1' | ForEach-Object { powershell -ExecutionPolicy Bypass -File $_.FullName }`

Expected: no output and exit code `0`.

- [ ] **Step 5: Commit**

```powershell
git add tools.html tests/web3-tools-content.test.ps1 docs/superpowers/specs/2026-08-13-web3-tools-directory-design.md
git commit -m "feat: expand personal Web3 tools directory"
```

## Self-review

- Spec coverage: Task 2 preserves the page and styling while adding the new title, nine tools, three groups, and safe links. Task 1 checks those contracts.
- Placeholder scan: the plan contains no incomplete markers or deferred work.
- Consistency: all tasks require the same three names, nine links, and safe anchor structure.
