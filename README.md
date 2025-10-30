## Zwift Offline for macOS安装部署（docker）

### 🚴🏻项目简介

Zwift Offline 私服允许你在本地运行 Zwift 环境，无需连接到官方服务器，提供更稳定的连接和自定义体验；

本项目主要用于macOS上快速安装、部署、更新 Zwift Offline服务，作为日常使用记录的备份；

参考来自： https://github.com/zoffline/zwift-offline.git

### 📁 文件说明

| 文件               | 说明                                                                             |
| ------------------ | -------------------------------------------------------------------------------- |
| bots.zip           | Zwift offline bot 机器人文件包，来自[https://github.com/oldnapalm/zoffline-bots] |
| deploy-zoffline.sh | Zwift offline 安装部署快捷命令脚本集合                                               |
| zwift-off.sh       | 切换到 Zwift offline 模式（修改 hosts 文件中 Zwift 域名指向 127.0.0.1）          |
| cert-zwift-com.pem | Zwift 证书文件，用于 SSL/TLS 加密连接                                            |
| docker-compose.yml | Zwift offline 容器配置文件，定义服务组合                                         |
| zwift-on.sh        | 切换到 Zwift online 模式，恢复原始设置                                           |
| zwift-update.sh    | Zwift offline 更新脚本，用于更新到最新版本                                       |

### ⚙️ 系统要求

操作系统: macOS 10.14 或更高版本

Docker: Docker Desktop 20.10+

权限: 需要管理员权限（用于修改 hosts 文件）

### 🚀快速开始

#### 1. 安装 Docker

确保你的 macOS 已安装 Docker Desktop：

Docker 官网 下载安装 https://www.docker.com/products/docker-desktop

#### 2. 安装 Zwift 客户端

确保你的 macOS 已安装 Zwift 客户端

Zwift 官网 下载安装 https://www.zwift.com

#### 3. 部署 Zwift Offline

给予执行权限,运行部署脚本;

```
chmod +x deploy-zoffline.sh
sh deploy-zoffline.sh

```

#### 4. 运行Zwift offline容器

切换到 Offline 模式（脚本会需要输入密码修改 hosts）

```
zwift-off
zwift-update
```

#### 5. 启动Zwift客户端

打开 Zwift 客户端

### 🛠️ 维护命令

#### 启动 Docker 服务

```
docker-compose up -d
```

#### 停止 Docker 服务

```
docker-compose down
```

#### 切换回 offline 模式

```
./zwift-off.sh
```

#### 切换回 online 模式

```
./zwift-on.sh

```

#### 检查服务状态

```
docker-compose ps
```

#### 查看日志

```
docker-compose logs
```

#### 更新 Zwift Offline

```
./zwift-update.sh
```

#### 停止并移除容器

```
docker-compose down
```

### ⚠️ 注意事项

权限要求: 切换模式脚本需要管理员权限修改 /etc/hosts 文件

网络冲突: 确保本地 80 、443、3024、3025、53端口未被其他应用占用

证书信任: 首次使用可能需要手动信任 cert-zwift-com.pem 证书

Zwift 更新: Zwift 客户端更新后可能需要更新 zoffline 服务

备份设置: 建议在使用前备份你的 Zwift 设置和存档


### 🔧 故障排除

常见问题

Q: 部署脚本执行失败
A: 检查 Docker 是否正常运行，尝试重启 Docker Desktop

Q: 无法连接到本地服务器
A: 确认 hosts 文件修改成功，检查端口是否被占用

Q: SSL 证书错误
A: 手动导入证书文件到系统钥匙串并设置为始终信任

Q: Bot 不工作
A: 解压 bots.zip 并检查配置文件路径


### 📝 许可证

本项目仅供学习和测试使用，请遵守相关软件的使用条款。

### 🤝 贡献

欢迎提交 Issue 和 Pull Request 来改进这个项目。

### 📞 支持

如遇问题，请检查：Docker 服务状态、主机 hosts 文件配置、网络端口占用情况、系统防火墙设置、科学上网；

注意: 本项目与 Zwift 官方无关，使用风险自负。
