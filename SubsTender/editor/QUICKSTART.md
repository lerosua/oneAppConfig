# SubsTender Editor - 快速启动指南

## 🚀 快速开始

### 方式一：使用启动脚本（推荐）

**macOS/Linux:**
```bash
cd editor
./start.sh
```

**Windows:**
```bash
cd editor
start.bat
```

### 方式二：手动启动

**1. 启动后端服务器**
```bash
cd editor/backend
npm start
```

**2. 启动前端（新终端窗口）**
```bash
cd editor/frontend
npm run dev
```

### 访问应用

浏览器打开：http://localhost:5173

---

## 📖 使用流程

1. **选择文件** - 右上角下拉菜单选择要编辑的 JSON 文件
2. **浏览数据** - 查看所有订阅服务的卡片列表
3. **搜索过滤** - 使用搜索框和分类过滤器快速定位
4. **编辑项目** - 点击"编辑"按钮修改数据
5. **添加新项** - 点击"添加新项"按钮创建新的订阅服务
6. **删除项目** - 点击删除图标移除不需要的项目
7. **保存更改** - 点击右下角的"保存更改"按钮将数据写回文件

---

## ⚙️ 端口配置

- **后端服务器**: http://localhost:3000
- **前端应用**: http://localhost:5173

---

## 🔧 常见问题

**Q: 端口被占用怎么办？**
A: 修改配置文件中的端口号
- 后端: `backend/server.js` 中的 `PORT` 变量
- 前端: `frontend/vite.config.js` 中的 `server.port`

**Q: 保存失败怎么办？**
A: 检查 JSON 格式是否正确，特别是套餐信息部分

**Q: 如何恢复误删的数据？**
A: 每次保存都会创建 `.backup` 备份文件，可以从备份恢复

---

## 📁 项目结构

```
editor/
├── backend/          # Express 后端服务器
├── frontend/         # Vue 3 前端应用
├── README.md         # 详细文档
├── start.sh          # macOS/Linux 启动脚本
└── start.bat         # Windows 启动脚本
```

---

## 💡 提示

- 编辑前建议先备份 JSON 文件
- 套餐信息使用 JSON 格式，注意语法正确性
- 未保存的更改会在右下角显示"保存更改"按钮
- 支持导入导出功能，方便数据迁移

---

更多详细信息请查看 [README.md](README.md)
