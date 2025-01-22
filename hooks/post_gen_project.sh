#!/usr/bin/env bash

cat > ".env" <<EOF
export USER_ID=$(id -u ${USER})
export GROUP_ID=$(id -g ${USER})
export USER_NAME="${USER}"
export DOTFILES_REPO=""
export DOTFILES_BRANCH=""
{%for env in cookiecutter.env_vars["array"] -%}
export {{ env }}=""
{% endfor -%}
EOF

if [[ ! -d ".git" ]]; then
	git init
	git add -A
	git commit -m "feat(project): initial commit from template"
fi
