FROM archlinux:base-devel

ARG USER_ID
ARG GROUP_ID
ARG USER_NAME
{% for arg in cookiecutter.docker_args["array"] -%}
ARG {{ arg }}
{% endfor -%}

RUN pacman --noconfirm -Syu
{% if cookiecutter.dependencies["array"] | length != 0 -%}
# Dependencies
RUN pacman --noconfirm -S {% for dep in cookiecutter.dependencies["array"] %}{{ dep }} {% endfor %}
{%- endif %}

{% if cookiecutter.dependencies_aur["array"] | length != 0 -%}
# Configuration for AUR
RUN pacman --sync --needed --noconfirm --noprogressbar sudo
RUN pacman --noconfirm --needed -S git
RUN useradd --system -s "/usr/bin/nologin" --create-home --home-dir "/home/aur_builder/" aur_builder 
RUN passwd --lock "aur_builder"
RUN echo "aur_builder ALL=(ALL) NOPASSWD: /usr/bin/pacman" > "/etc/sudoers.d/allow_${AUR_USER}_to_pacman"
RUN sudo -u "aur_builder" bash -c "git clone https://aur.archlinux.org/yay.git /home/aur_builder/yay"
RUN sudo -u "aur_builder" bash -c "cd /home/aur_builder/yay && makepkg -si --noconfirm --needed"
RUN sudo -u "aur_builder" bash -c "yay --noconfirm -S {% for dep in cookiecutter.dependencies_aur["array"] %}{{ dep }} {% endfor %}"
{%- endif %}

# Replicate the host user.
RUN groupadd -g ${GROUP_ID} ${USER_NAME} \
	&& useradd -l -s "/bin/bash" -u ${USER_ID} -g ${USER_NAME} ${USER_NAME} \
	&& install -d -m 0755 -o ${USER_NAME} -g ${USER_NAME} "/home/${USER_NAME}" \
	&& chown --changes --silent --no-dereference --recursive --from=33:33 \
		"${USER_ID}:${GROUP_ID}" "/home/${USER_NAME}"

USER ${USER_NAME}
WORKDIR /home/${USER_NAME}/project
{% for command in cookiecutter.extra_docker["array"] -%}
{{ command }}
{% endfor -%}
