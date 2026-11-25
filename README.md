# Antigravity CLI Eligibility Patcher (Windows x64)

本项目提供了一套本地脚本，用于解决 Antigravity CLI (v1.5.16 Windows x64) 出现的 `Eligibility check failed` 客户端拦截故障。本项目与 Google 无隶属或授权关系。

## ⚠️ 免责声明
**本项目仅供个人学习、逆向工程研究与本地故障排查使用。** 请勿将修改后的二进制文件（`.exe`）二次分发。

## 🚀 一键安装（推荐，小白专用）

1. 确保电脑上已安装 Antigravity CLI (v1.5.16)。
2. 下载本仓库的 `一键安装.bat`。
3. **双击运行它**（如果遇到 Windows 蓝色 SmartScreen 提示，请点击“更多信息” -> “仍要运行”）。
4. 脚本会自动关闭后台进程、备份原版，并将补丁**直接应用到你的 C 盘**。
5. 看到绿色的 `[完成]` 后，直接在命令行输入 `agy -p "Reply only with OK."` 测试即可。

*(注：如果你之前已经打过补丁，再次双击它会提示“无需重复安装”，绝对不会破坏文件。如果想还原，只需把 `C:\Users\用户名\.gemini\bin\agy.exe.bak` 改回 `agy.exe` 即可。)*

## 🛠️ 原理说明
通过静态分析，定位到 Go 二进制文件中的 `AuthStatus.EligibilityError` 函数。脚本将其入口处的 `TEST RAX, RAX` (`48 85 C0`) 强制修改为 `XOR EAX, EAX; NOP` (`31 C0 90`)，使其永远返回 `nil`（无错误），从而绕过拦截。

## 📌 适用版本与校验
- **目标版本**：1.5.16
- **平台**：Windows x64
- **原版 SHA-256**：`eaec8e3fc809df032dd8c496a86f6d53351942ec6c5cb7215d04f2c72a85bff8`
- **补丁版 SHA-256**：`77ab35fcf086044be910696f1b60ac7bec43f474d571cb5d5dcdf01b02b27b13`