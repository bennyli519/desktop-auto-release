# Desktop Release Automation - TODO

## ✅ 已完成

### Phase 1: Release Branch 初始化
- [x] 创建 `desktop-release-init.yml` workflow
- [x] 支持 `workflow_dispatch` 手动触发
- [x] 输入 bump_type (patch/minor/major)
- [x] 自动计算新版本号
- [x] 自动创建 `desktop/release-{version}` 分支
- [x] 自动 bump version 到所有 tauri.conf*.json 文件
- [x] Slack 通知 - Release 创建成功
- [x] 包含 cherry-pick 指令

### Phase 2: Version Bump
- [x] 集成到 Phase 1，自动完成
- [x] 更新 tauri.conf.json
- [x] 更新 tauri.conf.staging.json
- [x] 更新 tauri.conf.production.json

### Phase 3: Build Trigger
- [x] Staging build 使用 `workflow_call`
- [x] Production build 使用 `workflow_call`
- [x] 两个 build 并行触发（独立 approval）
- [x] 使用 GitHub Environments 进行审批控制

### Phase 4: Build Notifications
- [x] Staging build 完成通知
- [x] Production build 完成通知（正式 Release 公告格式）
- [x] 支持自定义 release description
- [x] 支持 release notes URL

---

## 🚧 待完成 (迁移到真实 repo 时)

### 环境配置
- [ ] 在 scribe-fe-v2 repo 创建 GitHub Environments
  - [ ] 创建 `staging` environment
  - [ ] 创建 `production` environment（设置 required reviewers）
- [ ] 添加 `SLACK_WEBHOOK_URL` secret（使用正式的 channel webhook）

### Workflow 迁移
- [ ] 复制 `desktop-release-init.yml` 到 scribe-fe-v2
- [ ] 修改 `desktop-app-publish-staging.yml`:
  - [ ] 添加 `workflow_call` trigger
  - [ ] 添加 `environment: staging`
- [ ] 修改 `desktop-app-publish-production.yml`:
  - [ ] 添加 `workflow_call` trigger  
  - [ ] 添加 `environment: production`

### 测试
- [ ] 在 staging 环境测试完整流程
- [ ] 验证 Slack 通知内容和格式
- [ ] 验证 CrabNebula 上传和下载链接

---

## 💡 未来优化 (Nice to Have)

### Cherry-pick 自动化
- [ ] Slack 交互式 cherry-pick（通过回复 commit SHA 自动 cherry-pick）
- [ ] 需要 Slack App + repository_dispatch

### 自动化测试
- [ ] Build 完成后自动下载安装包
- [ ] 基础冒烟测试（启动测试）

### Release Notes 生成
- [ ] 自动从 commits 生成 changelog
- [ ] 自动创建 GitHub Release

### 回滚机制
- [ ] 快速回滚到上一个版本的 workflow

---

## 📋 原始手动流程 vs 自动化

| 步骤 | 手动流程 | 自动化状态 |
|------|---------|-----------|
| 1. 创建 release branch | 手动 git checkout -b | ✅ 自动 |
| 2. Bump version | 手动编辑 3 个 json 文件 | ✅ 自动 |
| 3. Cherry-pick fixes | 手动 git cherry-pick | ⚠️ 半自动（提供指令） |
| 4. 创建 PR | 手动创建 | ❌ 手动 |
| 5. Code review | 手动 review | ❌ 手动 |
| 6. Merge PR | 手动 merge | ❌ 手动 |
| 7. 触发 staging build | 手动触发 workflow | ✅ 自动（需 approval） |
| 8. 验证 staging | 手动下载测试 | ⚠️ 提供下载链接 |
| 9. 触发 production build | 手动触发 workflow | ✅ 自动（需 approval） |
| 10. 验证 production | 手动下载测试 | ⚠️ 提供下载链接 |
| 11. 通知团队 | 手动发 Slack | ✅ 自动 |

**自动化覆盖率: ~70%**

