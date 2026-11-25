# GitHub 发布前检查清单

建议仓库名：`antigravity-cli-diagnostics`。

## 内容检查

- [ ] 在独立项目目录工作，而非直接上传整个软件工具目录。
- [ ] 核实 README、故障分析、测试报告之间的版本和平台一致。
- [ ] 确认实测、使用者自述和推断已明确区分。
- [ ] 不将单次 OK、版本输出或签名状态表述为长期可用性保证。
- [ ] 移除个人用户名、完整本机路径、账号、凭据、代理信息和项目私密数据。
- [ ] 只提交经过审查的研究文档；不提交第三方程序、修改程序、备份、资格绕过脚本或二进制补丁。
- [ ] 检查 `.gitignore`；注意忽略规则不会自动移除已跟踪文件。
- [ ] 核实自有内容的版权和任何引用、转载材料的授权。
- [x] 按作者提供的方案准备 MIT LICENSE。
- [ ] 发布前确认版权声明中的权利主体准确，MIT 授权仅涵盖有权授权的自有内容。

## 仓库准备

- [ ] 通过 https://github.com/new 创建独立仓库，先选择 Private。
- [ ] 添加已审查的文档，并逐个检查待提交文件清单。
- [ ] 检查首个提交的内容、文件名、README 渲染效果。
- [ ] 根据仓库可用功能启用秘密扫描和推送保护。
- [ ] 填写维护者认可的私密安全反馈渠道。
- [ ] 仅在全部审核通过后考虑公开可见性；在此之前不创建公开 Release。

## GitHub 官方参考

- 仓库创建：https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-new-repository
- 仓库快速入门：https://docs.github.com/en/repositories/creating-and-managing-repositories/quickstart-for-repositories
- 仓库安全：https://docs.github.com/en/code-security/getting-started/quickstart-for-securing-your-repository
- 敏感信息清理：https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/removing-sensitive-data-from-a-repository

完成此清单不代表第三方软件服务许可、账号资格或法律合规已经获得认可。
