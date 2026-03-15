<template>
  <div class="app-container">
    <!-- 顶部导航栏 -->
    <header class="app-header">
      <div class="header-content">
        <div class="logo-section">
          <el-icon :size="28" color="#409EFF"><Coin /></el-icon>
          <h1 class="app-title">SubsTender Editor</h1>
        </div>
        
        <div class="header-actions">
          <!-- 文件选择器 -->
          <el-select
            v-model="selectedFile"
            placeholder="选择文件"
            size="large"
            style="width: 220px; margin-right: 12px;"
            @change="loadFile"
          >
            <el-option
              v-for="file in files"
              :key="file"
              :label="file"
              :value="file"
            >
              <el-icon style="margin-right: 8px;"><Document /></el-icon>
              {{ file }}
            </el-option>
          </el-select>
          
          <!-- 导入导出按钮 -->
          <el-button-group>
            <el-button type="primary" @click="showImportDialog = true">
              <el-icon><Upload /></el-icon>
              导入
            </el-button>
            <el-button type="primary" @click="exportFile">
              <el-icon><Download /></el-icon>
              导出
            </el-button>
          </el-button-group>
        </div>
      </div>
    </header>

    <!-- 主内容区 -->
    <main class="app-main">
      <div class="main-content">
        <!-- 搜索和过滤栏 -->
        <div class="search-bar">
          <el-input
            v-model="searchQuery"
            placeholder="搜索名称、分类或关键词..."
            size="large"
            clearable
            class="search-input"
          >
            <template #prefix>
              <el-icon><Search /></el-icon>
            </template>
          </el-input>
          
          <el-select
            v-model="categoryFilter"
            placeholder="分类过滤"
            size="large"
            clearable
            style="width: 200px;"
          >
            <el-option
              v-for="cat in categories"
              :key="cat"
              :label="cat"
              :value="cat"
            />
          </el-select>
          
          <el-button type="success" size="large" @click="addNewItem">
            <el-icon><Plus /></el-icon>
            添加新项
          </el-button>
        </div>

        <!-- 数据卡片列表 -->
        <div v-if="filteredItems.length > 0" class="card-grid">
          <el-card
            v-for="(item, index) in filteredItems"
            :key="index"
            class="item-card"
            shadow="hover"
          >
            <template #header>
              <div class="card-header">
                <div class="card-title-section">
                  <el-avatar :size="40" class="card-avatar">
                    <img v-if="item.icon && item.icon.startsWith('http')" :src="item.icon" />
                    <el-icon v-else :size="24"><Box /></el-icon>
                  </el-avatar>
                  <span class="card-title">{{ item.name }}</span>
                </div>
              </div>
            </template>
            
            <div class="card-content">
              <div class="card-tags">
                <el-tag v-if="item.category" type="info" size="small">
                  {{ item.category }}
                </el-tag>
                <el-tag v-if="item.base_money" type="success" size="small">
                  {{ item.currency || '' }} {{ item.base_money }}
                </el-tag>
              </div>
              
              <div class="card-info">
                <div v-if="item.plan && item.plan.length > 0" class="info-item">
                  <el-icon><Grid /></el-icon>
                  <span>{{ item.plan.length }} 个套餐</span>
                </div>
                <div v-if="item.keyword" class="info-item">
                  <el-icon><Key /></el-icon>
                  <span>{{ item.keyword }}</span>
                </div>
                <div v-if="item.url" class="info-item">
                  <el-icon><Link /></el-icon>
                  <a :href="item.url" target="_blank" class="card-link">访问网站</a>
                </div>
              </div>
            </div>
            
            <template #footer>
              <div class="card-footer-actions">
                <el-button type="primary" text @click="editItem(index)">
                  <el-icon><Edit /></el-icon>
                  编辑
                </el-button>
                <el-button type="success" text @click="duplicateItem(index)">
                  <el-icon><CopyDocument /></el-icon>
                  复制
                </el-button>
              </div>
            </template>
          </el-card>
        </div>

        <!-- 空状态 -->
        <el-empty
          v-else
          description="没有找到匹配的数据"
          :image-size="200"
        />
      </div>
    </main>

    <!-- 保存按钮 -->
    <el-affix position="bottom" :offset="20" v-if="hasChanges">
      <div class="save-button-container">
        <el-button
          type="success"
          size="large"
          round
          @click="saveData"
        >
          <el-icon><Select /></el-icon>
          保存更改
        </el-button>
      </div>
    </el-affix>

    <!-- 编辑对话框 -->
    <el-dialog
      v-model="showEditDialog"
      :title="editingIndex === -1 ? '添加新项' : '编辑项目'"
      width="800px"
      :close-on-click-modal="false"
    >
      <el-form :model="editingItem" label-width="120px" label-position="left">
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="名称" required>
              <el-input v-model="editingItem.name" placeholder="请输入名称" />
            </el-form-item>
          </el-col>
          
          <el-col :span="12">
            <el-form-item label="分类">
              <el-select 
                v-model="editingItem.category" 
                placeholder="请选择或输入分类"
                filterable
                allow-create
                default-first-option
                style="width: 100%;"
              >
                <el-option
                  v-for="cat in categories"
                  :key="cat"
                  :label="cat"
                  :value="cat"
                />
              </el-select>
            </el-form-item>
          </el-col>
          
          <el-col :span="12">
            <el-form-item label="图标">
              <el-input v-model="editingItem.icon" placeholder="URL或名称" />
            </el-form-item>
          </el-col>
          
          <el-col :span="12">
            <el-form-item label="网址">
              <el-input v-model="editingItem.url" placeholder="https://" />
            </el-form-item>
          </el-col>
          
          <el-col :span="8">
            <el-form-item label="基础价格">
              <el-input-number
                v-model="editingItem.base_money"
                :min="0"
                :precision="2"
                style="width: 100%;"
              />
            </el-form-item>
          </el-col>
          
          <el-col :span="8">
            <el-form-item label="货币">
              <el-input v-model="editingItem.currency" placeholder="CNY/USD" />
            </el-form-item>
          </el-col>
          
          <el-col :span="8">
            <el-form-item label="免费试用天数">
              <el-input-number
                v-model="editingItem.free_trial"
                :min="0"
                style="width: 100%;"
              />
            </el-form-item>
          </el-col>
        </el-row>
        
        <el-row :gutter="20">
          <el-col :span="24">
            <el-form-item label="关键词">
              <el-input
                v-model="editingItem.keyword"
                placeholder="用逗号分隔多个关键词"
              />
            </el-form-item>
          </el-col>
        </el-row>
        
        <el-row :gutter="20" style="margin-top: 32px;">
          <el-col :span="24">
            <el-divider content-position="left">
              套餐信息
              <el-button 
                type="primary" 
                size="small" 
                @click="addPlan"
                style="margin-left: 10px;"
              >
                添加套餐
              </el-button>
            </el-divider>
            
            <!-- 套餐列表 -->
            <div v-if="editingItem.plan && editingItem.plan.length > 0" style="margin-bottom: 20px;">
              <el-card 
                v-for="(plan, planIndex) in editingItem.plan" 
                :key="planIndex"
                style="margin-bottom: 15px;"
                shadow="hover"
              >
                <template #header>
                  <div class="plan-card-header">
                    <div class="plan-title-section" @click="togglePlanCollapse(planIndex)">
                      <el-icon class="collapse-icon" :class="{ 'is-collapsed': planCollapsed[planIndex] }">
                        <ArrowDown />
                      </el-icon>
                      <span class="plan-title">套餐 {{ planIndex + 1 }}: {{ plan.name || '未命名' }}</span>
                    </div>
                    <el-button 
                      type="danger" 
                      size="small" 
                      @click="removePlan(planIndex)"
                      :icon="Delete"
                    >
                      删除套餐
                    </el-button>
                  </div>
                </template>
                
                <el-collapse-transition>
                  <div v-show="!planCollapsed[planIndex]">
                
                <el-row :gutter="20">
                  <el-col :span="12">
                    <el-form-item label="套餐名称">
                      <el-input v-model="plan.name" placeholder="例如：个人版" />
                    </el-form-item>
                  </el-col>
                  <el-col :span="12">
                    <el-form-item label="等级">
                      <el-input-number v-model="plan.level" :min="1" style="width: 100%;" />
                    </el-form-item>
                  </el-col>
                </el-row>
                
                <!-- 价格方案表格 -->
                <el-form-item label="价格方案">
                  <el-table 
                    :data="plan.suit || []" 
                    border 
                    style="width: 100%;"
                    v-if="plan.suit && plan.suit.length > 0"
                  >
                    <el-table-column label="周期" width="120">
                      <template #default="scope">
                        <el-input-number 
                          v-model="scope.row.cycle" 
                          :min="0" 
                          size="small"
                          style="width: 100%;"
                        />
                      </template>
                    </el-table-column>
                    
                    <el-table-column label="价格" width="120">
                      <template #default="scope">
                        <el-input 
                          v-model="scope.row.price" 
                          size="small"
                          placeholder="0"
                        />
                      </template>
                    </el-table-column>
                    
                    <el-table-column label="免费试用(天)" width="130">
                      <template #default="scope">
                        <el-input-number 
                          v-model="scope.row.free_trial" 
                          :min="0" 
                          size="small"
                          style="width: 100%;"
                        />
                      </template>
                    </el-table-column>
                    
                    <el-table-column label="描述">
                      <template #default="scope">
                        <el-input 
                          v-model="scope.row.desc" 
                          size="small"
                          placeholder="可选描述"
                        />
                      </template>
                    </el-table-column>
                    
                    <el-table-column label="操作" width="80" fixed="right">
                      <template #default="scope">
                        <el-button 
                          type="danger" 
                          size="small" 
                          @click="removeSuit(planIndex, scope.$index)"
                          :icon="Delete"
                          link
                        />
                      </template>
                    </el-table-column>
                  </el-table>
                  
                  <el-button 
                    type="primary" 
                    size="small" 
                    @click="addSuit(planIndex)"
                    style="margin-top: 10px;"
                  >
                    添加价格方案
                  </el-button>
                </el-form-item>
                
                <!-- 权益列表 -->
                <el-form-item label="权益列表">
                  <el-input
                    :model-value="getBenefitsText(planIndex)"
                    @input="updateBenefits(planIndex, $event)"
                    type="textarea"
                    :rows="6"
                    placeholder="每行一条权益，例如：&#10;无限存储空间&#10;支持多设备同步&#10;优先客服支持"
                  />
                  <div style="margin-top: 8px; font-size: 12px; color: #9ca3af;">
                    提示：每行输入一条权益，空行将被忽略
                  </div>
                </el-form-item>
                  </div>
                </el-collapse-transition>
              </el-card>
            </div>
            
            <el-empty 
              v-else 
              description="暂无套餐信息，点击上方按钮添加"
              :image-size="100"
            />
          </el-col>
        </el-row>
      </el-form>
      
      <template #footer>
        <div class="dialog-footer">
          <el-button 
            v-if="editingIndex !== -1" 
            type="danger" 
            plain
            @click="confirmDeleteFromEdit"
            class="delete-button-left"
          >
            <el-icon><Delete /></el-icon>
            删除此项
          </el-button>
          <div class="dialog-footer-spacer"></div>
          <div class="dialog-footer-right">
            <el-button @click="showEditDialog = false">取消</el-button>
            <el-button type="primary" @click="saveEdit">保存</el-button>
          </div>
        </div>
      </template>
    </el-dialog>

    <!-- 删除确认对话框 -->
    <el-dialog
      v-model="showDeleteDialog"
      title="确认删除"
      width="400px"
    >
      <el-alert
        title="此操作不可撤销"
        type="warning"
        :closable="false"
        show-icon
      >
        <p>确定要删除 <strong>{{ deleteItemName }}</strong> 吗？</p>
      </el-alert>
      
      <template #footer>
        <el-button @click="showDeleteDialog = false">取消</el-button>
        <el-button type="danger" @click="deleteItem">删除</el-button>
      </template>
    </el-dialog>

    <!-- 导入对话框 -->
    <el-dialog
      v-model="showImportDialog"
      title="导入JSON文件"
      width="500px"
    >
      <el-upload
        drag
        :auto-upload="false"
        :limit="1"
        accept=".json"
        :on-change="handleFileChange"
      >
        <el-icon class="el-icon--upload"><UploadFilled /></el-icon>
        <div class="el-upload__text">
          拖拽文件到此处或 <em>点击上传</em>
        </div>
        <template #tip>
          <div class="el-upload__tip">
            只支持 .json 格式文件
          </div>
        </template>
      </el-upload>
      
      <template #footer>
        <el-button @click="showImportDialog = false">取消</el-button>
        <el-button type="primary" @click="importData">导入</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import axios from 'axios'
import { ElMessage, ElMessageBox } from 'element-plus'
import {
  Search, Plus, Edit, Delete, Upload, Download, Document,
  Coin, Box, Grid, Key, Link, Select, UploadFilled, ArrowDown, CopyDocument
} from '@element-plus/icons-vue'

const API_BASE = '/api'

// 状态
const files = ref([])
const selectedFile = ref('')
const currentData = ref({ data: [] })
const originalData = ref(null)
const searchQuery = ref('')
const categoryFilter = ref(null)

// 编辑相关
const showEditDialog = ref(false)
const editingIndex = ref(-1)
const editingItem = ref({})
const planCollapsed = ref({}) // 套餐折叠状态

// 删除相关
const showDeleteDialog = ref(false)
const deleteIndex = ref(-1)
const deleteItemName = ref('')

// 导入相关
const showImportDialog = ref(false)
const importFileData = ref(null)

// 计算属性
const categories = computed(() => {
  const cats = new Set()
  currentData.value.data.forEach(item => {
    if (item.category) cats.add(item.category)
  })
  return Array.from(cats).sort()
})

const filteredItems = computed(() => {
  let items = currentData.value.data || []
  
  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase()
    items = items.filter(item => {
      return (
        item.name?.toLowerCase().includes(query) ||
        item.category?.toLowerCase().includes(query) ||
        item.keyword?.toLowerCase().includes(query)
      )
    })
  }
  
  if (categoryFilter.value) {
    items = items.filter(item => item.category === categoryFilter.value)
  }
  
  return items
})

const hasChanges = computed(() => {
  return JSON.stringify(currentData.value) !== JSON.stringify(originalData.value)
})

// 方法
const loadFiles = async () => {
  try {
    const response = await axios.get(`${API_BASE}/files`)
    if (response.data.success) {
      files.value = response.data.files
      if (files.value.length > 0 && !selectedFile.value) {
        selectedFile.value = files.value[0]
        await loadFile()
      }
    }
  } catch (error) {
    ElMessage.error('加载文件列表失败: ' + error.message)
  }
}

const loadFile = async () => {
  if (!selectedFile.value) return
  
  try {
    const response = await axios.get(`${API_BASE}/data/${selectedFile.value}`)
    if (response.data.success) {
      currentData.value = response.data.data
      originalData.value = JSON.parse(JSON.stringify(response.data.data))
      ElMessage.success('文件加载成功')
    }
  } catch (error) {
    ElMessage.error('加载文件失败: ' + error.message)
  }
}

const saveData = async () => {
  if (!selectedFile.value) {
    ElMessage.warning('请先选择文件')
    return
  }
  
  console.log('=== 开始保存 ===')
  console.log('文件名:', selectedFile.value)
  console.log('数据结构:', Object.keys(currentData.value))
  console.log('数据项数量:', currentData.value.data?.length)
  
  try {
    const payload = { data: currentData.value }
    console.log('发送的 payload:', payload)
    
    const response = await axios.post(`${API_BASE}/data/${selectedFile.value}`, payload)
    
    console.log('保存响应:', response.data)
    
    if (response.data.success) {
      originalData.value = JSON.parse(JSON.stringify(currentData.value))
      ElMessage.success('保存成功！')
    } else {
      ElMessage.error('保存失败: ' + (response.data.error || '未知错误'))
    }
  } catch (error) {
    console.error('保存错误:', error)
    ElMessage.error('保存失败: ' + (error.response?.data?.error || error.message))
  }
}

const addNewItem = () => {
  editingIndex.value = -1
  editingItem.value = {
    name: '',
    icon: '',
    url: '',
    category: '',
    keyword: '',
    currency: '',
    base_money: '',
    free_trial: 0,
    plan: []
  }
  showEditDialog.value = true
}

const editItem = (index) => {
  const actualIndex = currentData.value.data.indexOf(filteredItems.value[index])
  editingIndex.value = actualIndex
  editingItem.value = JSON.parse(JSON.stringify(currentData.value.data[actualIndex]))
  // 确保 plan 数组存在
  if (!editingItem.value.plan) {
    editingItem.value.plan = []
  }
  showEditDialog.value = true
}

const duplicateItem = (index) => {
  const actualIndex = currentData.value.data.indexOf(filteredItems.value[index])
  const originalItem = currentData.value.data[actualIndex]
  
  // 深拷贝原项目
  const duplicatedItem = JSON.parse(JSON.stringify(originalItem))
  
  // 修改名称，添加 +1
  duplicatedItem.name = originalItem.name + ' +1'
  
  // 插入到原项目后面
  currentData.value.data.splice(actualIndex + 1, 0, duplicatedItem)
  
  ElMessage.success('复制成功')
}

const saveEdit = () => {
  if (!editingItem.value.name) {
    ElMessage.warning('名称是必填项')
    return
  }
  
  // 清理空字段
  Object.keys(editingItem.value).forEach(key => {
    if (editingItem.value[key] === '') {
      delete editingItem.value[key]
    }
  })
  
  if (editingIndex.value === -1) {
    currentData.value.data.push(editingItem.value)
    ElMessage.success('添加成功')
  } else {
    currentData.value.data[editingIndex.value] = editingItem.value
    ElMessage.success('更新成功')
  }
  
  showEditDialog.value = false
}

const confirmDelete = (index) => {
  const actualIndex = currentData.value.data.indexOf(filteredItems.value[index])
  deleteIndex.value = actualIndex
  deleteItemName.value = currentData.value.data[actualIndex].name
  showDeleteDialog.value = true
}

const confirmDeleteFromEdit = () => {
  deleteIndex.value = editingIndex.value
  deleteItemName.value = editingItem.value.name
  showEditDialog.value = false
  showDeleteDialog.value = true
}

const deleteItem = () => {
  currentData.value.data.splice(deleteIndex.value, 1)
  showDeleteDialog.value = false
  ElMessage.success('删除成功')
}

const exportFile = async () => {
  if (!selectedFile.value) return
  
  try {
    const response = await axios.get(`${API_BASE}/export/${selectedFile.value}`, {
      responseType: 'blob'
    })
    
    const url = window.URL.createObjectURL(new Blob([response.data]))
    const link = document.createElement('a')
    link.href = url
    link.setAttribute('download', selectedFile.value)
    document.body.appendChild(link)
    link.click()
    link.remove()
    
    ElMessage.success('导出成功')
  } catch (error) {
    ElMessage.error('导出失败: ' + error.message)
  }
}

const handleFileChange = (file) => {
  importFileData.value = file.raw
}

const importData = async () => {
  if (!importFileData.value) {
    ElMessage.warning('请选择文件')
    return
  }
  
  const reader = new FileReader()
  
  reader.onload = (e) => {
    try {
      const data = JSON.parse(e.target.result)
      if (data.data && Array.isArray(data.data)) {
        currentData.value = data
        showImportDialog.value = false
        ElMessage.success('导入成功')
      } else {
        ElMessage.error('无效的JSON格式')
      }
    } catch (error) {
      ElMessage.error('解析JSON失败: ' + error.message)
    }
  }
  
  reader.readAsText(importFileData.value)
}

// 套餐管理方法
const togglePlanCollapse = (planIndex) => {
  planCollapsed.value[planIndex] = !planCollapsed.value[planIndex]
}

const addPlan = () => {
  if (!editingItem.value.plan) {
    editingItem.value.plan = []
  }
  editingItem.value.plan.push({
    name: '',
    level: 1,
    suit: [],
    benefits: []
  })
  // 新添加的套餐默认展开
  planCollapsed.value[editingItem.value.plan.length - 1] = false
}

const removePlan = (planIndex) => {
  editingItem.value.plan.splice(planIndex, 1)
}

const addSuit = (planIndex) => {
  if (!editingItem.value.plan[planIndex].suit) {
    editingItem.value.plan[planIndex].suit = []
  }
  editingItem.value.plan[planIndex].suit.push({
    cycle: 1,
    price: '',
    free_trial: 0,
    desc: ''
  })
}

const removeSuit = (planIndex, suitIndex) => {
  editingItem.value.plan[planIndex].suit.splice(suitIndex, 1)
}

const addBenefit = (planIndex) => {
  if (!editingItem.value.plan[planIndex].benefits) {
    editingItem.value.plan[planIndex].benefits = []
  }
  editingItem.value.plan[planIndex].benefits.push('')
}

const removeBenefit = (planIndex, benefitIndex) => {
  editingItem.value.plan[planIndex].benefits.splice(benefitIndex, 1)
}

// 权益文本处理方法
const getBenefitsText = (planIndex) => {
  const benefits = editingItem.value.plan[planIndex]?.benefits || []
  return benefits.join('\n')
}

const updateBenefits = (planIndex, text) => {
  if (!editingItem.value.plan[planIndex]) return
  
  // 将文本按行分割，过滤空行
  const benefits = text
    .split('\n')
    .map(line => line.trim())
    .filter(line => line.length > 0)
  
  editingItem.value.plan[planIndex].benefits = benefits
}

onMounted(() => {
  loadFiles()
})
</script>

<style scoped>
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

.app-container {
  min-height: 100vh;
  background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%);
  background-attachment: fixed;
}

/* 顶部导航栏 */
.app-header {
  background: rgba(30, 30, 46, 0.95);
  backdrop-filter: blur(20px);
  box-shadow: 0 4px 30px rgba(0, 0, 0, 0.3);
  border-bottom: 1px solid rgba(255, 255, 255, 0.06);
  position: sticky;
  top: 0;
  z-index: 1000;
}

.header-content {
  max-width: 1400px;
  margin: 0 auto;
  padding: 16px 24px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.logo-section {
  display: flex;
  align-items: center;
  gap: 12px;
}

.app-title {
  font-size: 24px;
  font-weight: 700;
  background: linear-gradient(135deg, #60a5fa 0%, #a78bfa 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.header-actions {
  display: flex;
  align-items: center;
  gap: 12px;
}

/* 主内容区 */
.app-main {
  padding: 32px 24px;
}

.main-content {
  max-width: 1400px;
  margin: 0 auto;
}

/* 搜索栏 */
.search-bar {
  background: rgba(30, 30, 46, 0.95);
  backdrop-filter: blur(20px);
  padding: 24px;
  border-radius: 16px;
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
  border: 1px solid rgba(255, 255, 255, 0.06);
  margin-bottom: 32px;
  display: flex;
  gap: 16px;
  align-items: center;
}

.search-input {
  flex: 1;
}

/* 卡片网格 */
.card-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
  gap: 24px;
}

.item-card {
  border-radius: 16px;
  overflow: hidden;
  transition: all 0.3s ease;
  border: 1px solid rgba(255, 255, 255, 0.06);
  background: rgba(30, 30, 46, 0.95);
  backdrop-filter: blur(20px);
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
}

.item-card:hover {
  transform: translateY(-8px);
  box-shadow: 0 12px 40px rgba(96, 165, 250, 0.3);
  background: rgba(40, 40, 60, 0.95);
  border-color: rgba(96, 165, 250, 0.5);
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.card-title-section {
  display: flex;
  align-items: center;
  gap: 12px;
  flex: 1;
  min-width: 0;
}

.card-avatar {
  flex-shrink: 0;
}

.card-title {
  font-size: 16px;
  font-weight: 600;
  color: #ffffff;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.card-content {
  padding: 8px 0;
}

.card-tags {
  display: flex;
  gap: 8px;
  margin-bottom: 16px;
  flex-wrap: wrap;
}

.card-info {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.info-item {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 14px;
  color: rgba(255, 255, 255, 0.9);
}

.card-link {
  color: #60a5fa;
  text-decoration: none;
  transition: color 0.3s;
}

.card-link:hover {
  color: #93c5fd;
  text-decoration: underline;
}

.card-footer-actions {
  display: flex;
  justify-content: flex-start;
  align-items: center;
  gap: 12px;
}

/* 套餐卡片样式 */
.plan-card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.plan-title-section {
  display: flex;
  align-items: center;
  gap: 12px;
  cursor: pointer;
  flex: 1;
  user-select: none;
}

.plan-title-section:hover .plan-title {
  color: #93c5fd;
}

.plan-title {
  font-size: 16px;
  font-weight: 600;
  color: #e5e7eb;
  transition: color 0.3s;
}

.collapse-icon {
  transition: transform 0.3s;
  color: #9ca3af;
}

.collapse-icon.is-collapsed {
  transform: rotate(-90deg);
}

/* 保存按钮 */
.save-button-container {
  display: flex;
  justify-content: center;
  padding: 0 20px 20px;
}

.save-button-container .el-button {
  box-shadow: 0 8px 24px rgba(103, 194, 58, 0.4);
  font-size: 16px;
  padding: 16px 32px;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .header-content {
    flex-direction: column;
    gap: 16px;
  }
  
  .header-actions {
    width: 100%;
    flex-direction: column;
  }
  
  .header-actions > * {
    width: 100%;
  }
  
  .search-bar {
    flex-direction: column;
  }
  
  .search-input {
    width: 100%;
  }
  
  .card-grid {
    grid-template-columns: 1fr;
  }
}

/* ��话框样式优化 */
:deep(.el-dialog) {
  border-radius: 16px;
  overflow: hidden;
  background: #1e1e2e;
  border: 1px solid rgba(255, 255, 255, 0.1);
}

:deep(.el-dialog__header) {
  background: linear-gradient(135deg, #60a5fa 0%, #a78bfa 100%);
  color: white;
  padding: 20px 24px;
}

:deep(.el-dialog__title) {
  color: white;
  font-weight: 600;
}

:deep(.el-dialog__headerbtn .el-dialog__close) {
  color: rgba(255, 255, 255, 0.9);
  font-size: 20px;
  width: 40px;
  height: 40px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 8px;
  transition: all 0.3s;
}

:deep(.el-dialog__headerbtn .el-dialog__close:hover) {
  background-color: rgba(255, 255, 255, 0.15);
  color: white;
}

:deep(.el-dialog__body) {
  background: #1e1e2e;
  color: #e5e7eb;
  max-height: 70vh;
  overflow-y: auto;
}

:deep(.el-dialog__footer) {
  background: #1e1e2e;
  border-top: 1px solid rgba(255, 255, 255, 0.08);
  padding: 16px 24px;
}

.dialog-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  width: 100%;
  gap: 20px;
}

.delete-button-left {
  margin-right: auto;
}

.dialog-footer-spacer {
  flex: 1;
}

.dialog-footer-right {
  display: flex;
  gap: 12px;
  margin-left: auto;
}

/* 上传组件样式 */
:deep(.el-upload-dragger) {
  border-radius: 12px;
  border: 2px dashed #d9d9d9;
  transition: all 0.3s;
}

:deep(.el-upload-dragger:hover) {
  border-color: #409EFF;
}

.el-icon--upload {
  font-size: 67px;
  color: #409EFF;
  margin: 40px 0 16px;
}

/* 卡片内的 Element Plus 组件样式 */
:deep(.el-card__header) {
  background: rgba(96, 165, 250, 0.08);
  border-bottom: 1px solid rgba(255, 255, 255, 0.06);
  padding: 16px 20px;
}

:deep(.el-card__body) {
  color: rgba(255, 255, 255, 0.85);
  background: transparent;
}

:deep(.el-card__footer) {
  background: rgba(0, 0, 0, 0.15);
  border-top: 1px solid rgba(255, 255, 255, 0.06);
  padding: 12px 20px;
}

/* 标签样式优化 */
:deep(.el-tag) {
  background: rgba(96, 165, 250, 0.15);
  border-color: rgba(96, 165, 250, 0.3);
  color: #bfdbfe;
  padding: 6px 16px;
  font-size: 13px;
}

:deep(.el-tag--info) {
  background: rgba(139, 92, 246, 0.15);
  border-color: rgba(139, 92, 246, 0.3);
  color: #c4b5fd;
}

:deep(.el-tag--success) {
  background: rgba(34, 197, 94, 0.15);
  border-color: rgba(34, 197, 94, 0.3);
  color: #86efac;
}

/* 表单和输入框暗色主题 */
:deep(.el-input__wrapper) {
  background-color: rgba(30, 30, 46, 0.6);
  box-shadow: 0 0 0 1px rgba(255, 255, 255, 0.06) inset;
}

:deep(.el-input__wrapper:hover) {
  box-shadow: 0 0 0 1px rgba(96, 165, 250, 0.3) inset;
}

:deep(.el-input__wrapper.is-focus) {
  box-shadow: 0 0 0 1px rgba(96, 165, 250, 0.5) inset;
}

:deep(.el-input__inner) {
  color: #d1d5db;
}

:deep(.el-textarea__inner) {
  background-color: rgba(30, 30, 46, 0.6);
  border-color: rgba(255, 255, 255, 0.06);
  color: #d1d5db;
}

:deep(.el-textarea__inner:hover) {
  border-color: rgba(96, 165, 250, 0.3);
}

:deep(.el-textarea__inner:focus) {
  border-color: rgba(96, 165, 250, 0.5);
}

:deep(.el-select__wrapper) {
  background-color: rgba(30, 30, 46, 0.6);
  box-shadow: 0 0 0 1px rgba(255, 255, 255, 0.06) inset;
}

:deep(.el-select__wrapper:hover) {
  box-shadow: 0 0 0 1px rgba(96, 165, 250, 0.3) inset;
}

:deep(.el-select__wrapper.is-focused) {
  box-shadow: 0 0 0 1px rgba(96, 165, 250, 0.5) inset;
}

:deep(.el-form-item__label) {
  color: #9ca3af;
}

:deep(.el-table) {
  background-color: rgba(30, 30, 46, 0.4);
  color: #d1d5db;
}

:deep(.el-table th.el-table__cell) {
  background-color: rgba(96, 165, 250, 0.1);
  color: #d1d5db;
  border-color: rgba(255, 255, 255, 0.06);
}

:deep(.el-table tr) {
  background-color: transparent;
}

:deep(.el-table td.el-table__cell) {
  border-color: rgba(255, 255, 255, 0.06);
}

:deep(.el-table__body tr:hover > td) {
  background-color: rgba(96, 165, 250, 0.08);
}

:deep(.el-divider__text) {
  background-color: #1e1e2e;
  color: #a78bfa;
  font-weight: 500;
  font-size: 15px;
}

:deep(.el-divider) {
  border-color: rgba(255, 255, 255, 0.06);
}

:deep(.el-empty__description p) {
  color: #6b7280;
}

:deep(.el-card) {
  background-color: rgba(40, 40, 60, 0.4);
  border-color: rgba(255, 255, 255, 0.06);
}

/* 按钮内边距优化 */
:deep(.el-button) {
  padding: 10px 20px;
  font-size: 14px;
}

:deep(.el-button--large) {
  padding: 13px 24px;
  font-size: 15px;
}

:deep(.el-button--small) {
  padding: 7px 15px;
  font-size: 13px;
}

/* 圆形按钮修复 */
:deep(.el-button.is-circle) {
  padding: 8px;
  border-radius: 50%;
  width: 32px;
  height: 32px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
}

:deep(.el-button--small.is-circle) {
  width: 28px;
  height: 28px;
  padding: 6px;
}

/* 下拉菜单暗色主题 */
:deep(.el-select-dropdown) {
  background-color: #1e1e2e;
  border: 1px solid rgba(255, 255, 255, 0.1);
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.4);
}

:deep(.el-select-dropdown__item) {
  color: #e5e7eb;
}

:deep(.el-select-dropdown__item:hover) {
  background-color: rgba(96, 165, 250, 0.2);
}

:deep(.el-select-dropdown__item.is-selected) {
  color: #60a5fa;
  background-color: rgba(96, 165, 250, 0.15);
  font-weight: 600;
}

:deep(.el-select-dropdown__item.is-hovering) {
  background-color: rgba(96, 165, 250, 0.2);
}

:deep(.el-popper.is-light) {
  background-color: #1e1e2e;
  border-color: rgba(255, 255, 255, 0.1);
}

:deep(.el-popper.is-light .el-popper__arrow::before) {
  background-color: #1e1e2e;
  border-color: rgba(255, 255, 255, 0.1);
}

/* 选择器图标颜色 */
:deep(.el-select .el-icon) {
  color: #9ca3af;
}

:deep(.el-input__prefix .el-icon) {
  color: #9ca3af;
}

:deep(.el-input__suffix .el-icon) {
  color: #9ca3af;
}

/* 按钮组样式优化 */
:deep(.el-button-group .el-button) {
  border-color: rgba(255, 255, 255, 0.2);
}

:deep(.el-button-group .el-button:hover) {
  border-color: rgba(96, 165, 250, 0.5);
}

/* 输入框占位符颜色 */
:deep(.el-input__inner::placeholder) {
  color: #6b7280;
}

:deep(.el-textarea__inner::placeholder) {
  color: #6b7280;
}

/* 数字输入框按钮 */
:deep(.el-input-number__decrease),
:deep(.el-input-number__increase) {
  background-color: rgba(30, 30, 46, 0.8);
  border-color: rgba(255, 255, 255, 0.1);
  color: #9ca3af;
}

:deep(.el-input-number__decrease:hover),
:deep(.el-input-number__increase:hover) {
  color: #60a5fa;
}

</style>
