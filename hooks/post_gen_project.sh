#!/usr/bin/env bash

cat > "file.txt" <<EOF
export USER_ID=$(id -u ${USER})
export GROUP_ID=$(id -g ${USER})
export USER_NAME="${USER}"
{% for arg in cookiecutter.docker_args["array"] %}
export {{ arg }}=""
{% endfor %}
EOF
