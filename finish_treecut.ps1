# ============================================================
# 树剪整理补完脚本（处理首次整理中断/遗漏的剩余步骤）
# 幂等设计：已完成的步骤自动跳过
# ============================================================
$ErrorActionPreference = 'Continue'
$dst = 'E:\树剪整理'
$log = "$dst\_整理日志.txt"
function Log($msg) { $line = "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $msg"; Write-Output $line; Add-Content -Path $log -Value $line -Encoding UTF8 }
function SafeMove($src, $dest) {
  if (-not (Test-Path $src)) { Log "SKIP(not exist): $src"; return }
  if (Test-Path $dest) { Log "SKIP(target exists): $dest"; return }
  try { Move-Item -Path $src -Destination $dest -Force -ErrorAction Stop; Log "MOVED: $src -> $dest" }
  catch { Log "FAIL: $src -> $dest :: $($_.Exception.Message)" }
}
Log '===== FINISH-PASS START ====='
SafeMove 'G:\树剪TreeCut_v12.2_完整部署' "$dst\05_清理备份\v12.2_旧部署_G盘完整部署"
New-Item -ItemType Directory -Path "$dst\05_清理备份\主程序内部备份" -Force | Out-Null
$srcRoot = "$dst\01_主程序源码\树剪软件相关文件"
if (Test-Path $srcRoot) {
  foreach ($b in @('backup_20260611_035634','backup_20260611_113924','backup_20260611_114508','backup_optimize_20260611_151504','evolution_backups','archived_dead_code')) { SafeMove "$srcRoot\$b" "$dst\05_清理备份\主程序内部备份\$b" }
  Get-ChildItem $srcRoot -Recurse -Directory -Filter '__pycache__' -ErrorAction SilentlyContinue | ForEach-Object { Remove-Item $_.FullName -Recurse -Force -ErrorAction SilentlyContinue; Log "REMOVED(pycache): $($_.FullName)" }
  foreach ($f in @('crash_log.txt','upgrade_log.txt','generate_log.txt','self_evolver_log.txt','batch_generate_5_log.txt','audit_log_20260713.json','audit_report.json','MODEL_VALIDATION_PASSED.txt')) { SafeMove "$srcRoot\$f" "$dst\05_清理备份\主程序内部备份\$f" }
} else { Log "WARN: $srcRoot not found" }
$sh = New-Object -ComObject WScript.Shell
$newTarget = "$dst\02_安装程序\TreeCut_v13\启动树剪v13.cmd"
if (Test-Path $newTarget) {
  try { $lnk = $sh.CreateShortcut('C:\Users\admin\Desktop\树剪 TreeCut.lnk'); $lnk.TargetPath = $newTarget; $lnk.WorkingDirectory = "$dst\02_安装程序\TreeCut_v13"; $lnk.Save(); Log "UPDATED shortcut: $newTarget" } catch { Log "FAIL shortcut: $($_.Exception.Message)" }
} else { Log "WARN: $newTarget not found" }
Log '===== FINISH-PASS DONE ====='