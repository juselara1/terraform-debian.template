FROM archlinux:latest

ARG USER_ID
ARG GROUP_ID
ARG USER_NAME
{% for arg in cookiecutter.docker_args["array"] %}
ARG {{ arg }}
{% endfor %}

RUN pacman --noconfirm -Syu

{% if cookiecutter.dependencies["array"] | length != 0 %}
# Dependencies
RUN pacman --noconfirm -S {% for dep in cookiecutter.dependencies["array"] %}{{ dep }} {% endfor %}
{% endif %}

# Replicate the host user.
RUN groupadd -g ${GROUP_ID} ${USER_NAME} \
	&& useradd -l -s "/bin/bash" -u ${USER_ID} -g ${USER_NAME} ${USER_NAME} \
	&& install -d -m 0755 -o ${USER_NAME} -g ${USER_NAME} "/home/${USER_NAME}" \
	&& chown --changes --silent --no-dereference --recursive --from=33:33 \
		"${USER_ID}:${GROUP_ID}" "/home/${USER_NAME}"

USER ${USER_NAME}
WORKDIR /home/${USER_NAME}/project
{% for command in cookiecutter.extra_docker["array"] %}
{{ command }}
{% endfor %}
