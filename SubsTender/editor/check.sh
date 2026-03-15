#!/bin/bash

echo "🔍 检查 SubsTender Editor 安装..."
echo ""

# 检查 Node.js
if ! command -v node &> /dev/null; then
    echo "❌ Node.js 未安装"
    echo "   请访问 https://nodejs.org 下载安装"
    exit 1
else
    echo "✅ Node.js 已安装: $(node --version)"
fi

# 检查 npm
if ! command -v npm &> /dev/null; then
    echo "❌ npm 未安装"
    exit 1
else
    echo "✅ npm 已安装: $(npm --version)"
fi

echo ""
echo "📦 检查依赖..."

# 检查后端依赖
if [ -d "backend/node_modules" ]; then
    echo "✅ 后端依赖已安装"
else
    echo "⚠️  后端依赖未安装"
    echo "   运行: cd backend && npm install"
fi

# 检查前端依赖
if [ -d "frontend/node_modules" ]; then
    echo "✅ 前端依赖已安装"
else
    echo "⚠️  前端依赖未安装"
    echo "   运行: cd frontend && npm install"
fi

echo ""
echo "📁 检查数据文件..."

# 检查 JSON 文件
cd ..
if [ -f "zh-hans.json" ]; then
    echo "✅ zh-hans.json 存在"
else
    echo "⚠️  zh-hans.json 不存在"
fi

if [ -f "en.json" ]; then
    echo "✅ en.json 存在"
else
    echo "⚠️  en.json 不存在"
fi

if [ -f "ja.json" ]; then
    echo "✅ ja.json 存在"
else
    echo "⚠️  ja.json 不存在"
fi

if [ -f "vendor.json" ]; then
    echo "✅ vendor.json 存在"
else
    echo "⚠️  vendor.json 不存在"
fi

echo ""
echo "🎉 检查完成！"
echo ""
echo "运行 ./start.sh 启动应用"
