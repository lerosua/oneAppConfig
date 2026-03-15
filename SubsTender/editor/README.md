# SubsTender Editor

一个基于 Vue 3 + Element Plus + Express 的现代化本地 JSON 数据编辑工具，用于管理订阅服务数据。

## ✨ 界面预览

现代化渐变背景 + 毛玻璃效果 + 流畅动画，打造极致的视觉体验！

## 功能特性

✅ **文件管理**
- 右上角下拉菜单选择不同的 JSON 文件
- 支持 zh-hans.json, ja.json, en.json, vendor.json 等文件

✅ **数据展示**
- 现代化渐变背景设计
- 毛玻璃效果卡片
- 流畅的悬停动画
- 显示服务名称、图标、分类、价格等信息
- 响应式布局，适配各种屏幕尺寸

✅ **编辑功能**
- 点击卡片进入编辑模式
- 支持编辑所有字段（包括嵌套的 plan 和 suit）
- 表单验证确保数据完整性

✅ **添加/删除**
- 快速添加新的订阅项
- 删除前确认对话框

✅ **搜索过滤**
- 按名称、分类、关键词实时搜索
- 分类下拉过滤

✅ **导入导出**
- 拖拽上传 JSON 文件
- 导出当前编辑的数据

✅ **数据保存**
- 保存按钮将数据写回原 JSON 文件
- 自动创建备份文件（.backup）
- 实时显示是否有未保存的更改

## 技术栈

**前端：**
- Vue 3 (Composition API)
- Element Plus (现代化 UI 组件库)
- Vite (极速开发服务器)
- Axios (HTTP 请求)

**后端：**
- Node.js
- Express
- CORS

## 项目结构

```
SubsTender/
├── editor/
│   ├── backend/
│   │   ├── server.js          # Express 服务器
│   │   └── package.json
│   ├── frontend/
│   │   ├── src/
│   │   │   ├── App.vue        # 主应用组件
│   │   │   └── main.js        # 入口文件
│   │   ├── index.html
│   │   ├── package.json
│   │   └── vite.config.js
│   └── README.md
├── zh-hans.json               # 中文数据
├── ja.json                    # 日文数据
├── en.json                    # 英文数据
└── vendor.json                # 供应商数据
```

## 安装和运行

### 1. 安装依赖

```bash
# 安装后端依赖
cd editor/backend
npm install

# 安装前端依赖
cd ../frontend
npm install
```

### 2. 启动服务

**方式一：分别启动（推荐用于开发）**

```bash
# 终端1：启动后端服务器
cd editor/backend
npm start

# 终端2：启动前端开发服务器
cd editor/frontend
npm run dev
```

**方式二：使用启动脚本**

```bash
# 在 SubsTender 目录下
cd editor
chmod +x start.sh
./start.sh
```

### 3. 访问应用

打开浏览器访问：`http://localhost:5173`

## API 接口

后端服务器运行在 `http://localhost:3000`，提供以下 API：

- `GET /api/files` - 获取所有 JSON 文件列表
- `GET /api/data/:filename` - 读取指定 JSON 文件
- `POST /api/data/:filename` - 保存到指定 JSON 文件
- `POST /api/import` - 导入 JSON 文件
- `GET /api/export/:filename` - 导出 JSON 文件
- `GET /api/health` - 健康检查

## 使用说明

### 1. 选择文件
点击右上角的文件选择下拉菜单，选择要编辑的 JSON 文件。

### 2. 浏览数据
- 使用搜索框按名称、分类或关键词搜索
- 使用分类过滤器筛选特定分类的项目

### 3. 编辑项目
- 点击卡片上的"编辑"按钮
- 在弹出的对话框中修改字段
- 套餐信息使用 JSON 格式编辑
- 点击"保存"确认更改

### 4. 添加新项
- 点击"添加新项"按钮
- 填写必填字段（名称）
- 可选填写其他字段和套餐信息
- 点击"保存"添加

### 5. 删除项目
- 点击卡片上的删除图标
- 在确认对话框中确认删除

### 6. 保存更改
- 编辑后，右下角会出现"保存更改"按钮
- 点击按钮将更改写入 JSON 文件
- 原文件会自动备份为 `.backup` 文件

### 7. 导入导出
- 点击右上角的上传图标导入 JSON 文件
- 点击下载图标导出当前文件

## 数据格式

JSON 文件应遵循以下格式：

```json
{
  "data": [
    {
      "name": "服务名称",
      "icon": "图标URL或名称",
      "url": "服务网址",
      "category": "分类",
      "keyword": "关键词",
      "currency": "货币类型",
      "base_money": "基础价格",
      "free_trial": 免费试用天数,
      "plan": [
        {
          "name": "套餐名称",
          "level": 等级,
          "suit": [
            {
              "cycle": 周期,
              "free_trial": 免费试用,
              "price": "价格",
              "desc": "描述"
            }
          ],
          "benefits": ["权益1", "权益2"]
        }
      ]
    }
  ]
}
```

### 字段说明

- `cycle`: 1=周, 2=月, 3=季, 4=年, 5=永久
- `level`: 套餐等级，数字越大等级越高
- `benefits`: 套餐权益列表

## 注意事项

1. **数据备份**：每次保存时会自动创建 `.backup` 备份文件
2. **JSON 格式**：编辑套餐信息时请确保 JSON 格式正确
3. **端口占用**：确保 3000 和 5173 端口未被占用
4. **浏览器兼容**：推荐使用 Chrome、Firefox、Edge 等现代浏览器

## 故障排除

### 后端无法启动
- 检查 3000 端口是否被占用
- 确认已安装 Node.js (v16+)
- 重新安装依赖：`npm install`

### 前端无法访问
- 检查 5173 端口是否被占用
- 确认后端服务已启动
- 检查浏览器控制台错误信息

### 无法保存文件
- 检查文件权限
- 确认 JSON 格式正确
- 查看后端控制台错误信息

## 开发

### 构建生产版本

```bash
cd editor/frontend
npm run build
```

构建后的文件在 `frontend/dist` 目录。

### 修改端口

**后端端口**：修改 `backend/server.js` 中的 `PORT` 变量

**前端端口**：修改 `frontend/vite.config.js` 中的 `server.port`

## License

MIT
