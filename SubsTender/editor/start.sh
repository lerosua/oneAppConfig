#!/bin/bash

echo "🚀 启动 SubsTender Editor..."
echo ""

# 检查是否安装了依赖
if [ ! -d "backend/node_modules" ]; then
    echo "📦 安装后端依赖..."
    cd backend && npm install && cd ..
fi

if [ ! -d "frontend/node_modules" ]; then
    echo "📦 安装前端依赖..."
    cd frontend && npm install && cd ..
fi

echo ""
echo "✅ 依赖检查完成"
echo ""
echo "🔧 启动后端服务器 (端口 3000)..."
cd backend && npm start &
BACKEND_PID=$!

echo "🎨 启动前端开发服务器 (端口 5173)..."
cd ./frontend && npm run dev &
FRONTEND_PID=$!

echo ""
echo "✨ 服务已启动！"
echo ""
echo "📝 后端: http://localhost:3000"
echo "🌐 前端: http://localhost:5173"
echo ""
echo "按 Ctrl+C 停止所有服务"
echo ""

# 等待用户中断
trap "echo ''; echo '🛑 停止服务...'; kill $BACKEND_PID $FRONTEND_PID; exit" INT

wait
