#!/bin/bash

# =================================================================================
# Docker CE (Community Edition) on Ubuntu - Official Installation Script
# =================================================================================
# 이 스크립트는 Docker 공식 문서를 기반으로 작성되었으며,
# Ubuntu에 Docker를 설치하는 권장 절차를 자동화합니다.
#
# 실행 방법:
# 1. 파일 저장: 이 코드를 install_docker.sh 라는 이름으로 저장
# 2. 실행 권한 부여: chmod +x install_docker.sh
# 3. 스크립트 실행: ./install_docker.sh
# =================================================================================

# 스크립트 실행 중 오류 발생 시 즉시 중단
set -e

# --- 1. 사전 준비: 기존 Docker 관련 패키지 제거 및 시스템 업데이트 ---
echo "[단계 1/5] 기존 Docker 패키지를 제거하고 시스템을 업데이트합니다..."
# 오래된 버전이 설치되어 있을 경우 충돌을 방지하기 위해 제거합니다.
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do
  if dpkg -l | grep -q $pkg; then
    sudo apt-get remove -y $pkg
  fi
done

sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg

# --- 2. Docker 공식 GPG 키 추가 ---
echo "[단계 2/5] Docker의 공식 GPG 키를 추가합니다..."
# apt가 Docker 저장소를 신뢰할 수 있도록 GPG 키를 설정합니다.
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# --- 3. Docker APT 저장소 설정 ---
echo "[단계 3/5] Docker의 APT 저장소를 시스템에 추가합니다..."
# apt 소스 리스트에 Docker 공식 저장소를 추가합니다.
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# --- 4. Docker Engine 설치 ---
echo "[단계 4/5] Docker Engine을 설치합니다..."
sudo apt-get update
# 최신 버전의 Docker 관련 패키지들을 설치합니다.
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# --- 5. 설치 후 작업: 현재 사용자를 docker 그룹에 추가 ---
echo "[단계 5/5] 현재 사용자를 'docker' 그룹에 추가합니다..."
# sudo 없이 docker 명령어를 사용하기 위해 현재 사용자를 docker 그룹에 추가합니다.
# 이 설정은 터미널을 재시작하거나 재로그인해야 적용됩니다.
sudo usermod -aG docker $USER

# =================================================================================
# 설치 완료!
# =================================================================================
echo ""
echo "✅ Docker 설치가 성공적으로 완료되었습니다."
echo "✅ Docker Compose Plugin도 함께 설치되었습니다."
echo ""
echo "🔴 중요: 'sudo' 없이 docker 명령어를 사용하려면, 현재 터미널을 닫고 새로 열거나 시스템에 다시 로그인해야 합니다."
echo "   또는 'newgrp docker' 명령어를 실행하여 현재 세션에 그룹 변경을 즉시 적용할 수 있습니다."
echo ""
echo "설치 확인을 위해 다음 명령어를 실행해 보세요 (새 터미널에서):"
echo "docker --version"
echo "docker compose version"
echo "docker run hello-world"
echo ""