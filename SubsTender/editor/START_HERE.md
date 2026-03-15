# 🚀 新 UI 启动指南

## 欢迎使用全新的 SubsTender Editor！

我们已经将 UI 从 Material Design 升级为现代化设计风格。

## 🎨 新 UI 预览

### 主要特色
- 🌈 **渐变紫色背景** - 从 #667eea 到 #764ba2 的优雅渐变
- 💎 **毛玻璃效果** - 半透明卡片 + 背景模糊
- ✨ **流畅动画** - 悬停时卡片上浮 8px
- 🎯 **圆角设计** - 16px 圆角，更柔和
- 📤 **拖拽上传** - 直接拖拽 JSON 文件导入

## 📋 启动步骤

### 1️⃣ 确保依赖已安装

```bash
cd editor

# 检查环境
./check.sh
```

如果提示依赖未安装，运行：

```bash
# 安装后端依赖
cd backend
npm install

# 安装前端依赖
cd ../frontend
npm install
```

### 2️⃣ 启动应用

**方式一：使用启动脚本（推荐）**

```bash
cd editor
./start.sh        # macOS/Linux
# 或
start.bat         # Windows
```

**方式二：手动启动**

```bash
# 终端 1 - 启动后端
cd editor/backend
npm start

# 终端 2 - 启动前端
cd editor/frontend
npm run dev
```

### 3️⃣ 访问应用

打开浏览器访问：**http://localhost:5173**

## 🎯 快速体验

1. **选择文件** - 右上角下拉菜单选择 JSON 文件
2. **浏览数据** - 查看漂亮的卡片列表
3. **悬停卡片** - 看看流畅的上浮动画
4. **搜索过滤** - 试试搜索功能
5. **编辑数据** - 点击"编辑"按钮
6. **拖拽上传** - 试试新的拖拽上传功能

## 🎨 视觉亮点

### 背景
```
渐变紫色背景，固定不滚动
从左上到右下的优雅过渡
```

### 卡片
```
白色半透明 (95% 不透明度)
10px 背景模糊效果
16px 圆角
悬停时上浮 8px + 阴影加深
```

### 顶部栏
```
白色半透明导航栏
毛玻璃效果
粘性定位，滚动时保持在顶部
```

## 📱 响应式测试

试试调整浏览器窗口大小：

- **宽屏** (>1400px): 4-5 列卡片
- **桌面** (1024-1400px): 3-4 列卡片
- **平板** (768-1024px): 2-3 列卡片
- **手机** (<768px): 1 列卡片

## 🔧 端口信息

- **后端 API**: http://localhost:3000
- **前端应用**: http://localhost:5173

## ⚠️ 常见问题

### 端口被占用
如果 5173 端口被占用，修改 `frontend/vite.config.js`:

```js
server: {
  port: 5174, // 改成其他端口
  ...
}
```

### 样式没有加载
确保 Element Plus 已正确安装：

```bash
cd frontend
npm list element-plus
```

### 图标不显示
确保图标库已安装：

```bash
cd frontend
npm list @element-plus/icons-vue
```

## 🎉 享受新 UI

新 UI 保留了所有原有功能，只是变得更漂亮了！

**主要改进：**
- ✅ 更现代的视觉设计
- ✅ 更流畅的动画效果
- ✅ 更好的用户体验
- ✅ 更轻量的包体积
- ✅ 更快的加载速度

## 📚 更多信息

- 完整文档: `README.md`
- UI 更新说明: `UI_UPDATE.md`
- 新旧对比: `UI_COMPARISON.md`
- 升级总结: `UI_UPGRADE_SUMMARY.md`

---

**准备好了吗？运行 `./start.sh` 开始体验吧！** 🚀
