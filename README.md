# Base Cookiecutter Template for Arch Linux
---

This `cookiecutter` template creates an isolated and complete development environment in `docker` using `debian` as the base image, and shares the same host user and ssh keys.

Example usage:

```sh
cat > "/tmp/config.yml" <<EOF
default_context:
    project_name: Development environment
    project_slut: devenv
    nvim_version: v0.10.3
    debian_version: bookworm-slim
    env_vars: 
        array: []
EOF
cookiecutter \
    --no-input \
    --config-file "/tmp/config.yml" \
    "https://github.com/juselara1/base-debian.template"
```
