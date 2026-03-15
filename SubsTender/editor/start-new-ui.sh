#!/bin/bash

echo "════════════════════════════════════════════════════════"
echo "   🎨 SubsTender Editor - 全新毛玻璃设计"
echo "════════════════════════════════════════════════════════"
echo ""
echo "✨ 最新更新："
echo "   • 半透明毛玻璃卡片"
echo "   • 渐变紫色背景"
echo "   • 白色文字 + 阴影"
echo "   • 流畅悬停动画"
echo ""
echo "════════════════════════════════════════════════════════"
echo ""

# 检查依赖
if [ ! -d "frontend/node_modules/element-plus" ]; then
    echo "📦 正在安装 Element Plus..."
    cd frontend && npm install && cd ..
fi

if [ ! -d "backend/node_modules" ]; then
    echo "📦 正在安装后端依赖..."
    cd backend && npm install && cd ..
fi

echo "🚀 启动服务..."
echo ""

# 启动后端
cd backend && npm start &
BACKEND_PID=$!

sleep 2

# 启动前端
cd ../frontend && npm run dev &
FRONTEND_PID=$!

echo ""
echo "════════════════════════════════════════════════════════"
echo "   ✅ 服务已启动！"
echo "════════════════════════════════════════════════════════"
echo ""
echo "📝 后端 API:  http://localhost:3000"
echo "🎨 前端应用:  http://localhost:5173"
echo ""
echo "🎯 新特性："
echo "   • 半透明毛玻璃卡片 (15% 白色 + 20px 模糊)"
echo "   • 白色文字清晰可见"
echo "   • 悬停时卡片变亮并上浮"
echo "   • 整体风格统一协调"
echo ""
echo "════════════════════════════════════════════════════════"
echo ""
echo "按 Ctrl+C 停止所有服务"
echo ""

# 等待用户中断
trap "echo ''; echo '🛑 停止服务...'; kill $BACKEND_PID $FRONTEND_PID 2>/dev/null; exit" INT

wait
