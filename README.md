# node android docker image

Base docker image with node and android for ionic or cordova.

Usage:

```bash
docker run --rm -v `pwd`:/app -w /app abcfy2/node_android npx -p ionic -p cordova -- ionic build ...
```

Gitlab CI example:

```yaml
variables:
  GRADLE_OPTS: '-Dorg.gradle.daemon=false'

build:
  image: abcfy2/node_android
  script:
  - npm ci
  - npx -p ionic -p cordova -- ionic cordova build android --prod --release ...
```
