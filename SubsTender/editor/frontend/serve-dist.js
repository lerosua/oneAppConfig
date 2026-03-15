import express from 'express';
import { createProxyMiddleware } from 'http-proxy-middleware';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();
const PORT = 3002;

// 代理 API 请求���后端
app.use('/api', createProxyMiddleware({
  target: 'http://localhost:3000',
  changeOrigin: true
}));

// 提供静态文件
app.use(express.static(path.join(__dirname, 'dist')));

// SPA 路由支持
app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, 'dist', 'index.html'));
});

app.listen(PORT, () => {
  console.log(`Static server running on http://localhost:${PORT}`);
  console.log(`API proxy: http://localhost:${PORT}/api -> http://localhost:3000/api`);
});
