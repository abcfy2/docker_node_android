# node android docker image

![Docker Build (Debian)](https://github.com/abcfy2/docker_node_android/actions/workflows/docker_build_debian.yml/badge.svg)
![Docker Build (Alpine)](https://github.com/abcfy2/docker_node_android/actions/workflows/docker_build_alpine.yml/badge.svg)
[![Docker Pulls](https://img.shields.io/docker/pulls/abcfy2/node_android)](https://hub.docker.com/r/abcfy2/node_android)
[![Latest Tag](https://img.shields.io/docker/v/abcfy2/node_android?sort=semver)](https://hub.docker.com/r/abcfy2/node_android/tags)

Base docker image with node and android for ionic or cordova.

Github repository: [abcfy2/docker_node_android](https://github.com/abcfy2/docker_node_android)

## Supported tags and respective `Dockerfile` links

- [latest](https://github.com/abcfy2/docker_node_android/blob/main/Dockerfile.debian)
- [18[-slim]](https://github.com/abcfy2/docker_node_android/blob/main/Dockerfile.debian)
- [16[-slim]](https://github.com/abcfy2/docker_node_android/blob/main/Dockerfile.debian)
- [14[-slim]](https://github.com/abcfy2/docker_node_android/blob/main/Dockerfile.debian)
- [12[-slim]](https://github.com/abcfy2/docker_node_android/blob/main/Dockerfile.debian)
- [10[-slim]](https://github.com/abcfy2/docker_node_android/blob/main/Dockerfile.debian)
- [alpine](https://github.com/abcfy2/docker_node_android/blob/main/Dockerfile.alpine)
- [18-alpine](https://github.com/abcfy2/docker_node_android/blob/main/Dockerfile.alpine)
- [16-alpine](https://github.com/abcfy2/docker_node_android/blob/main/Dockerfile.alpine)
- [14-alpine](https://github.com/abcfy2/docker_node_android/blob/main/Dockerfile.alpine)
- [12-alpine](https://github.com/abcfy2/docker_node_android/blob/main/Dockerfile.alpine)
- [10-alpine](https://github.com/abcfy2/docker_node_android/blob/main/Dockerfile.alpine)

Also, all tags should append `-java8/java11` to use JAVA 8 or 11, if not provided, default should be **JAVA 8**.

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

Working with Gitlab CI cache example:

```yaml
variables:
  ANDROID_SDK_ROOT: "${CI_PROJECT_DIR}/android-sdk"
  ANDROID_HOME: "${CI_PROJECT_DIR}/android-sdk"
  NPM_CONFIG_CACHE: "${CI_PROJECT_DIR}/npm_cache"
  GRADLE_USER_HOME: "${CI_PROJECT_DIR}/gradle_cache"
  GRADLE_OPTS: "-Dorg.gradle.daemon=false -Dfile.encoding=UTF-8"

default:
  before_script:
    - yes | sdkmanager --sdk_root="${ANDROID_SDK_ROOT}" --licenses || true
  after_script:
    - GRADLE_WRAPPER_DIR="${GRADLE_USER_HOME:-${HOME}/.gradle}/wrapper"
    - '[ -d "${GRADLE_WRAPPER_DIR}" ] && find "${GRADLE_WRAPPER_DIR}" -name "gradle-*.zip" -delete || true'
  cache:
    paths:
      - ${ANDROID_SDK_ROOT}
      - ${NPM_CONFIG_CACHE}
      - ${GRADLE_USER_HOME}/caches/
      - ${GRADLE_USER_HOME}/wrapper/
# ... your build steps here
```
