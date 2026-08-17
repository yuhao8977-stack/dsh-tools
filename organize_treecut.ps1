# ============================================================
# 树剪程序文件整理脚本（一键整理）
# 目标：将散落在 E 盘、桌面、下载、G盘的树剪文件统一整理到 E:\树剪整理
# 结构：01_主程序源码 / 02_安装程序 / 03_草稿视频导出 / 04_文档资料 / 05_清理备份
# 用法：以管理员身份运行（E 盘根目录需要管理员权限创建文件夹）
# ============================================================
$ErrorActionPreference = 'Continue'
$dst = 'E:\树剪整理'
$log = "$dst\_整理日志.txt"
$subDirs = @('01_主程序源码','02_安装程序','03_草稿视频导出','04_文档资料','05_清理备份')
function Log([string]$msg) { $line = "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $msg"; Write-Output $line; Add-Content -Path $log -Value $line -Encoding UTF8 }
function SafeMove([string]$src, [string]$dest) {
  if (-not (Test-Path $src)) { Log "SKIP(源不存在): $src"; return }
  if (Test-Path $dest) { Log "SKIP(目标已存在): $dest"; return }
  try { Move-Item -Path $src -Destination $dest -Force -ErrorAction Stop; Log "MOVED: $src -> $dest" }
  catch { Log "FAIL: $src -> $dest :: $($_.Exception.Message)" }
}
New-Item -ItemType Directory -Path $dst -Force | Out-Null
foreach ($d in $subDirs) { New-Item -ItemType Directory -Path (Join-Path $dst $d) -Force | Out-Null }
Log "===== 树剪整理开始 ($dst) ====="
$runningPy = @(Get-Process pythonw -ErrorAction SilentlyContinue)
if ($runningPy.Count -gt 0) { Log "WARN: 检测到 $($runningPy.Count) 个 pythonw 进程在运行！TreeCut_v13 本体暂不移动" } else { Log "OK: 无 pythonw 进程，可安全移动 TreeCut_v13" }
SafeMove 'E:\树剪软件相关文件' "$dst\01_主程序源码\树剪软件相关文件"
SafeMove 'E:\树剪草稿视频导出' "$dst\03_草稿视频导出\树剪草稿视频导出"
if ($runningPy.Count -eq 0) { SafeMove 'E:\树剪安装包\TreeCut_v13' "$dst\02_安装程序\TreeCut_v13" }
foreach ($f in @('TreeCut_v13_CPU_Setup.exe','TreeCut_v13_CPU_Setup-1.bin','TreeCut_v13_CPU_Setup-2.bin','TreeCut_v13_CPU_Setup-3.bin','TreeCut_v13_CPU_Setup-4.bin','TreeCut_v13_CPU_Setup-5.bin','TreeCut_v13_CPU_Setup-6.bin','TreeCut_v13_CPU_Setup-7.bin','node-v24.19.0-x64.msi')) { SafeMove "E:\树剪安装包\$f" "$dst\02_安装程序\$f" }
New-Item -ItemType Directory -Path "$dst\02_安装程序\调试脚本" -Force | Out-Null
Get-ChildItem 'E:\树剪安装包' -Filter *.cmd -File -ErrorAction SilentlyContinue | ForEach-Object { SafeMove $_.FullName "$dst\02_安装程序\调试脚本\$($_.Name)" }
if ((Test-Path 'E:\树剪安装包') -and -not (Get-ChildItem 'E:\树剪安装包' -Force -ErrorAction SilentlyContinue)) { Remove-Item 'E:\树剪安装包' -Force; Log "REMOVED(空目录): E:\树剪安装包" }
SafeMove 'C:\Users\admin\Desktop\树剪_TreeCut_程序详细说明文档.docx' "$dst\04_文档资料\树剪_TreeCut_程序详细说明文档.docx"
SafeMove 'C:\Users\admin\Desktop\树剪程序导图.pdf' "$dst\04_文档资料\树剪程序导图.pdf"
SafeMove 'C:\Users\admin\Downloads\TreeCut_升级任务包_v8.2_to_v10.md' "$dst\04_文档资料\TreeCut_升级任务包_v8.2_to_v10.md"
SafeMove 'C:\Users\admin\Desktop\树剪TreeCut_v12.2_部署包.zip' "$dst\05_清理备份\v12.2_旧部署包_树剪TreeCut_v12.2.zip"
SafeMove 'C:\Users\admin\Desktop\树剪_v3.0_代码_第1部分.xlsx' "$dst\05_清理备份\桌面版_树剪_v3.0_代码_第1部分.xlsx"
SafeMove 'C:\Users\admin\Desktop\树剪_v3.0_代码_第2部分.xlsx' "$dst\05_清理备份\桌面版_树剪_v3.0_代码_第2部分.xlsx"
SafeMove 'C:\Users\admin\Downloads\TreeCut_v13_CPU_Setup (1).exe' "$dst\05_清理备份\重复_安装包_TreeCut_v13_CPU_Setup_副本.exe"
SafeMove 'E:\treecut_wipe.bat' "$dst\05_清理备份\treecut_wipe.bat"
SafeMove 'E:\treecut_wipe2.bat' "$dst\05_清理备份\treecut_wipe2.bat"
SafeMove 'G:\树剪TreeCut_v12.2_完整部署' "$dst\05_清理备份\v12.2_旧部署_G盘完整部署"
if ((Test-Path 'E:\treecut_test_materials') -and -not (Get-ChildItem 'E:\treecut_test_materials' -Force -ErrorAction SilentlyContinue)) { Remove-Item 'E:\treecut_test_materials' -Force; Log "REMOVED(空目录): E:\treecut_test_materials" }
$srcRoot = "$dst\01_主程序源码\树剪软件相关文件"
if (Test-Path $srcRoot) {
  New-Item -ItemType Directory -Path "$dst\05_清理备份\主程序内部备份" -Force | Out-Null
  foreach ($b in @('backup_20260611_035634','backup_20260611_113924','backup_20260611_114508','backup_optimize_20260611_151504','evolution_backups','archived_dead_code')) { SafeMove "$srcRoot\$b" "$dst\05_清理备份\主程序内部备份\$b" }
  Get-ChildItem $srcRoot -Recurse -Directory -Filter '__pycache__' -ErrorAction SilentlyContinue | ForEach-Object { Remove-Item $_.FullName -Recurse -Force -ErrorAction SilentlyContinue; Log "REMOVED(pycache): $($_.FullName)" }
  foreach ($f in @('crash_log.txt','upgrade_log.txt','generate_log.txt','self_evolver_log.txt','batch_generate_5_log.txt','audit_log_20260713.json','audit_report.json','MODEL_VALIDATION_PASSED.txt')) { SafeMove "$srcRoot\$f" "$dst\05_清理备份\主程序内部备份\$f" }
}
$sh = New-Object -ComObject WScript.Shell
$newTarget = "$dst\02_安装程序\TreeCut_v13\启动树剪v13.cmd"
if (Test-Path $newTarget) {
  try { $lnk = $sh.CreateShortcut('C:\Users\admin\Desktop\树剪 TreeCut.lnk'); $lnk.TargetPath = $newTarget; $lnk.WorkingDirectory = "$dst\02_安装程序\TreeCut_v13"; $lnk.Save(); Log "UPDATED: 桌面\树剪 TreeCut.lnk -> $newTarget" } catch { Log "FAIL: 更新快捷方式 :: $($_.Exception.Message)" }
}
if (Test-Path 'C:\Users\admin\Desktop\树剪.lnk') { Remove-Item 'C:\Users\admin\Desktop\树剪.lnk' -Force; Log "REMOVED: 桌面\树剪.lnk（旧版快捷方式）" }
Log "===== 树剪整理结束 ====="