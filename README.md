# Web IDE 초기화 스크립트

이 프로젝트는 웹 기반 IDE 환경을 자동으로 설정하는 스크립트를 제공합니다.

## 기능

- Docker 자동 설치
- Code Server 컨테이너 자동 설정
- Public IP 자동 설정
- 프로젝트 디렉토리 자동 생성

## 요구사항

- Linux 운영체제
- sudo 권한
- 인터넷 연결

## 설치 방법

1. 저장소 클론:
```bash
git clone https://github.com/cwj3688/init-webide.git
cd init-webide
```

2. VM 생성시 init 스크립트 실행:
```bash
#!/bin/bash

# 스크립트 실행 중 오류 발생시 즉시 중단
set -e

# 웹 IDE 초기화를 위한 저장소 URL과 디렉토리, 이미지 이름 설정
REPO_URL="https://github.com/cwj3688/init-webide.git"
REPO_DIR="init-webide"
IMAGE_NAME="code-server-hol3"
PROJECT_DIR="/home/ubuntu/project"

# 저장소 클론 및 디렉토리 이동
git clone "$REPO_URL"
cd "$REPO_DIR"

# Docker 설치 스크립트 실행
chmod +x install_docker.sh
./install_docker.sh

# Public IP 업데이트 스크립트 실행
chmod +x update_ip.sh
./update_ip.sh

# Docker 이미지 빌드
docker build -t "$IMAGE_NAME" .

# Docker 그룹 ID 가져와서 컨테이너 실행
DOCKER_GID=$(getent group docker | cut -d: -f3) docker compose up -d

# 프로젝트 디렉토리 생성 및 권한 설정
mkdir -p "$PROJECT_DIR"
chown -R 1000:1000 "$PROJECT_DIR"
chown -R 1000:1000 ~/
```

## 파일 구조

- `install_docker.sh`: Docker 설치 스크립트
- `update_ip.sh`: Public IP 업데이트 스크립트
- `Dockerfile`: Code Server 이미지 빌드 파일
- `docker-compose.yml`: 컨테이너 구성 파일
- `Caddyfile`: Caddy 서버 설정 파일

## 접속 방법

스크립트 실행이 완료되면 다음 URL로 접속할 수 있습니다:
```
http://<Public-IP>.sslip.io
```

