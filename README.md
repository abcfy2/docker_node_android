# node android docker image

Base docker image with node and android for ionic or cordova.

Github repository: [abcfy2/docker_node_android](https://github.com/abcfy2/docker_node_android)

## Supported tags and respective `Dockerfile` links

- [latest](https://github.com/abcfy2/docker_node_android/blob/main/Dockerfile.debian)
- [16](https://github.com/abcfy2/docker_node_android/blob/main/Dockerfile.debian)
- [14](https://github.com/abcfy2/docker_node_android/blob/main/Dockerfile.debian)
- [12](https://github.com/abcfy2/docker_node_android/blob/main/Dockerfile.debian)
- [10](https://github.com/abcfy2/docker_node_android/blob/main/Dockerfile.debian)
- [alpine](https://github.com/abcfy2/docker_node_android/blob/main/Dockerfile.alpine)
- [16-alpine](https://github.com/abcfy2/docker_node_android/blob/main/Dockerfile.alpine)
- [14-alpine](https://github.com/abcfy2/docker_node_android/blob/main/Dockerfile.alpine)
- [12-alpine](https://github.com/abcfy2/docker_node_android/blob/main/Dockerfile.alpine)
- [10-alpine](https://github.com/abcfy2/docker_node_android/blob/main/Dockerfile.alpine)

## Usage

```bash
docker run --rm -v `pwd`:/app -w /app abcfy2/node_android npx -p ionic -p cordova -- ionic build ...
```

Gitlab CI example:

```yaml
variables:
  GRADLE_OPTS: "-Dorg.gradle.daemon=false"

build:
  image: abcfy2/node_android:<tag>
  script:
    - npm ci
    - npx -p ionic -p cordova -- ionic cordova build android --prod --release ...
```
