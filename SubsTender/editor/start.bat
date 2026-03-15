@echo off
echo 🚀 启动 SubsTender Editor...
echo.

REM 检查是否安装了依赖
if not exist "backend\node_modules" (
    echo 📦 安装后端依赖...
    cd backend
    call npm install
    cd ..
)

if not exist "frontend\node_modules" (
    echo 📦 安装前端依赖...
    cd frontend
    call npm install
    cd ..
)

echo.
echo ✅ 依赖检查完成
echo.
echo 🔧 启动后端服务器 (端口 3000)...
start "SubsTender Backend" cmd /k "cd backend && npm start"

timeout /t 2 /nobreak > nul

echo 🎨 启动前端开发服务器 (端口 5173)...
start "SubsTender Frontend" cmd /k "cd frontend && npm run dev"

echo.
echo ✨ 服务已启动！
echo.
echo 📝 后端: http://localhost:3000
echo 🌐 前端: http://localhost:5173
echo.
echo 关闭窗口以停止服务
echo.

pause
