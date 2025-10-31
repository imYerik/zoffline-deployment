#!/bin/bash

echo "====== `date` Updating zwift offline container ======"

export PATH=$PATH:/usr/local/bin
ZWIFT_BASE=~/Documents/Zwift-offline
compose_file=${ZWIFT_BASE}/scripts/docker-compose.yml
image_name="zoffline/zoffline" 
image_tag="latest" 
container_name="zoffline"

# 检查更新镜像
check_and_update_image() {
    local image_name=$1
    local tag=${2:-"latest"}
    local full_image="$image_name:$tag"

    echo "检查镜像: $full_image"
    
    # 方法1：直接比较镜像ID（推荐）
    local current_id=$(docker images --no-trunc --quiet "$full_image" 2>/dev/null)
    
    if [ -z "$current_id" ]; then
        echo "本地镜像不存在，开始拉取..."
        docker pull "$full_image"
        return 0
    fi
    
    #echo "当前镜像ID: ${current_id:0:12}"
    echo "当前镜像ID: ${current_id}"
    
    # 拉取最新镜像
    echo "正在检查远端更新..."
    docker pull "$full_image"
    
    local new_id=$(docker images --no-trunc --quiet "$full_image")
    
    if [ "$current_id" = "$new_id" ]; then
        echo "✓ 镜像已是最新版本"
        return 1
    else
        echo "✓ 镜像已更新"
        echo "旧ID: ${current_id:0:12}"
        echo "新ID: ${new_id:0:12}"
        return 0
    fi
}

# 检查容器状态
check_and_start_with_inspect() {
    local container_name=$1
    
    echo "检查容器状态: $container_name"
    
    # 检查容器是否存在
    if ! docker inspect "$container_name" &>/dev/null; then
        echo "❌ 容器 $container_name 不存在,创建并启动容器"
        docker-compose -f "$compose_file" up -d
        return 2
    fi
    
    # 获取容器运行状态
    local status
    status=$(docker inspect --format='{{.State.Status}}' "$container_name" 2>/dev/null)
    
    case "$status" in
        "running")
            echo "✅ 容器 $container_name 正在运行"
            return 0
            ;;
        "paused")
            echo "⏸️ 容器 $container_name 已暂停"
            if docker unpause "$container_name"; then
                echo "✅ 容器 $container_name 启动成功"
                return 0
            fi
            ;;
        "exited"|"created")
            echo "⚠️  容器 $container_name 状态: $status，尝试启动..."
            if docker start "$container_name"; then
                echo "✅ 容器 $container_name 启动成功"
                return 0
            else
                echo "❌ 容器 $container_name 启动失败"
                return 1
            fi
            ;;
        *)
            echo "❓ 容器 $container_name 状态未知: $status"
            return 3
            ;;
    esac
}


# 检查更新镜像,如果更新，则重新创建并启动容器
if check_and_update_image $image_name $image_tag; then
    docker-compose -f "$compose_file" down && docker-compose -f "$compose_file" up -d 
    # 清理旧镜像
    echo "✓ 清理旧镜像"
    docker image prune -f
else
    # 检查容器状态
    check_and_start_with_inspect "$container_name"

fi

