#!/bin/bash

echo "🎨 SubsTender Editor - 新 UI 测试"
echo ""
echo "正在检查环境..."
echo ""

# 检查依赖
if [ ! -d "frontend/node_modules/element-plus" ]; then
    echo "❌ Element Plus 未安装"
    echo "正在安装依赖..."
    cd frontend && npm install && cd ..
else
    echo "✅ Element Plus 已安装"
fi

if [ ! -d "backend/node_modules" ]; then
    echo "❌ 后端依赖未安装"
    echo "正在安装依赖..."
    cd backend && npm install && cd ..
else
    echo "✅ 后端依赖已安装"
fi

echo ""
echo "🚀 启动服务..."
echo ""
echo "📝 后端服务: http://localhost:3000"
echo "🎨 前端应用: http://localhost:5173"
echo ""
echo "⚡ 新 UI 特性:"
echo "   • 渐变紫色背景"
echo "   • 毛玻璃效果卡片"
echo "   • 流畅悬停动画"
echo "   • 拖拽上传文件"
echo ""
echo "按 Ctrl+C 停止服务"
echo ""

# 启动后端
cd backend && npm start &
BACKEND_PID=$!

# 等待后端启动
sleep 2

# 启动前端
cd ../frontend && npm run dev &
FRONTEND_PID=$!

# 等待用户中断
trap "echo ''; echo '🛑 停止服务...'; kill $BACKEND_PID $FRONTEND_PID 2>/dev/null; exit" INT

wait
