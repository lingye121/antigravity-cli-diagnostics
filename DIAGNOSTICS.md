# 故障诊断与分析报告

## 现象

作者报告：在 Windows 环境下，原版 CLI 可以启动并读取版本，但发起模型请求时返回 `Eligibility check failed`。

## 静态分析记录

作者通过 Ghidra 加载符号表，定位到与认证及错误处理相关的 `validateEligibilityWithRetry` 和 `AuthStatus.EligibilityError`。作者认为后者与客户端资格错误对象的构造有关。

## 证据边界

本报告基于作者提供的 1.5.16 版本静态分析记录。打包过程未重新反汇编原始可执行文件，也未独立验证函数行为。二进制内容发生修改后，原始数字签名的完整性校验可能失败（`HashMismatch`）。即使一次请求返回正常结果，也不能证明账号获得官方授权或长期稳定可用。
