import express from 'express';
import cors from 'cors';
import fs from 'fs/promises';
import path from 'path';
import { fileURLToPath } from 'url';
import multer from 'multer';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();
const PORT = 3000;

// 数据文件目录（上两级目录）
const DATA_DIR = path.join(__dirname, '..', '..');

// 配置multer用于文件上传
const upload = multer({ dest: 'uploads/' });

app.use(cors());
app.use(express.json({ limit: '50mb' }));

// 获取所有JSON文件列表
app.get('/api/files', async (req, res) => {
  try {
    const files = await fs.readdir(DATA_DIR);
    const jsonFiles = files.filter(file => file.endsWith('.json'));
    res.json({ success: true, files: jsonFiles });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
});

// 读取指定JSON文件
app.get('/api/data/:filename', async (req, res) => {
  try {
    const { filename } = req.params;
    
    // 安全检查：只允许读取.json文件
    if (!filename.endsWith('.json')) {
      return res.status(400).json({ success: false, error: 'Invalid file type' });
    }
    
    const filePath = path.join(DATA_DIR, filename);
    const data = await fs.readFile(filePath, 'utf-8');
    const jsonData = JSON.parse(data);
    
    res.json({ success: true, data: jsonData });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
});

// 保存到指定JSON文件
app.post('/api/data/:filename', async (req, res) => {
  try {
    const { filename } = req.params;
    const { data } = req.body;
    
    console.log('=== Save Request ===');
    console.log('Filename:', filename);
    console.log('Data structure:', data ? Object.keys(data) : 'null');
    console.log('Data.data is array:', data && data.data && Array.isArray(data.data));
    
    // 安全检查
    if (!filename.endsWith('.json')) {
      return res.status(400).json({ success: false, error: 'Invalid file type' });
    }
    
    // 验证JSON格式
    if (!data || !data.data || !Array.isArray(data.data)) {
      console.log('Validation failed:', { hasData: !!data, hasDataData: !!(data && data.data), isArray: data && data.data && Array.isArray(data.data) });
      return res.status(400).json({ success: false, error: 'Invalid data format' });
    }
    
    const filePath = path.join(DATA_DIR, filename);
    
    // 备份原文件
    try {
      const backupPath = path.join(DATA_DIR, `${filename}.backup`);
      await fs.copyFile(filePath, backupPath);
    } catch (backupError) {
      console.warn('Backup failed:', backupError.message);
    }
    
    // 写入新数据
    await fs.writeFile(filePath, JSON.stringify(data, null, 2), 'utf-8');
    
    console.log('File saved successfully:', filePath);
    
    res.json({ success: true, message: 'File saved successfully' });
  } catch (error) {
    console.error('Save error:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

// 导入JSON文件
app.post('/api/import', upload.single('file'), async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ success: false, error: 'No file uploaded' });
    }
    
    const data = await fs.readFile(req.file.path, 'utf-8');
    const jsonData = JSON.parse(data);
    
    // 验证数据格式
    if (!jsonData.data || !Array.isArray(jsonData.data)) {
      return res.status(400).json({ success: false, error: 'Invalid JSON format' });
    }
    
    // 清理上传的临时文件
    await fs.unlink(req.file.path);
    
    res.json({ success: true, data: jsonData });
  } catch (error) {
    // 清理临时文件
    if (req.file) {
      try {
        await fs.unlink(req.file.path);
      } catch (e) {}
    }
    res.status(500).json({ success: false, error: error.message });
  }
});

// 导出JSON文件
app.get('/api/export/:filename', async (req, res) => {
  try {
    const { filename } = req.params;
    
    if (!filename.endsWith('.json')) {
      return res.status(400).json({ success: false, error: 'Invalid file type' });
    }
    
    const filePath = path.join(DATA_DIR, filename);
    const data = await fs.readFile(filePath, 'utf-8');
    
    res.setHeader('Content-Type', 'application/json');
    res.setHeader('Content-Disposition', `attachment; filename="${filename}"`);
    res.send(data);
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
});

// 健康检查
app.get('/api/health', (req, res) => {
  res.json({ success: true, message: 'Server is running' });
});

app.listen(PORT, () => {
  console.log(`SubsTender Editor Backend running on http://localhost:${PORT}`);
  console.log(`Data directory: ${DATA_DIR}`);
});
