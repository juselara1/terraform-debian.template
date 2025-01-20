# Base Cookiecutter Template for Arch Linux
---

This `cookiecutter` template creates an isolated and complete development environment in `docker` using `arch-linux` as the base image, and shares the same host user and ssh keys.

Example usage:

```sh
cat > "/tmp/config.yml" <<EOF
default_context:
    project_name: Development environment
    project_slut: devenv
    dependencies:
        array: [
            base-devel, git, chezmoi, openssh, neovim, tmux, starship, zoxide, fzf
        ]
    docker_args:
        array: [DOTFILES_REPO, DOTFILES_BRANCH]
    extra_docker:
        array:
            - RUN chezmoi init --apply --depth=1 --branch=\${DOTFILES_BRANCH} \${DOTFILES_REPO}

EOF
cookiecutter \
    --no-input \
    --config-file "/tmp/config.yml" \
    "https://github.com/juselara1/base-arch.template"
```
