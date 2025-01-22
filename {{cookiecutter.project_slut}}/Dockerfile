# neovim builder
FROM debian:{{ cookiecutter.debian_version }} AS nvim_build
RUN apt update -y && apt install -y --no-install-recommends \
	git build-essential ca-certificates cmake ninja-build gettext curl
RUN update-ca-certificates
RUN git clone https://github.com/neovim/neovim.git /tmp/neovim --depth 1 --branch {{ cookiecutter.nvim_version }} \
	&& cd /tmp/neovim \
	&& make install

# starship builder
FROM debian:{{ cookiecutter.debian_version }} AS fzf_build
RUN apt update -y && apt install -y --no-install-recommends curl ca-certificates
RUN update-ca-certificates
RUN curl -sS https://starship.rs/install.sh > install.sh && chmod +x install.sh
RUN ./install.sh --yes

# zoxide builder
FROM debian:{{ cookiecutter.debian_version }} AS zoxide_build
RUN apt update -y && apt install -y --no-install-recommends curl ca-certificates
RUN update-ca-certificates
RUN curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

# chezmoi builder
FROM debian:{{ cookiecutter.debian_version }} AS chezmoi_build
RUN apt update -y && apt install -y --no-install-recommends curl ca-certificates
RUN update-ca-certificates
RUN sh -c "$(curl -fsLS get.chezmoi.io)"

# main image
FROM debian:{{ cookiecutter.debian_version }}
ARG USER_ID
ARG GROUP_ID
ARG USER_NAME
ARG DOTFILES_REPO
ARG DOTFILES_BRANCH

COPY --from=nvim_build /usr/local/bin/nvim /usr/local/bin/nvim
COPY --from=nvim_build /usr/local/share/nvim /usr/local/share/nvim
COPY --from=fzf_build /usr/local/bin/starship /usr/local/bin/starship
COPY --from=zoxide_build /root/.local/bin/zoxide /usr/local/bin/zoxide
COPY --from=chezmoi_build /bin/chezmoi /usr/local/bin/chezmoi

RUN apt update -y && apt install -y --no-install-recommends \
	curl ca-certificates git tmux fzf openssh-client
RUN update-ca-certificates

# Replicate the host user.
RUN groupadd -g ${GROUP_ID} ${USER_NAME} \
	&& useradd -l -s "/bin/bash" -u ${USER_ID} -g ${USER_NAME} ${USER_NAME} \
	&& install -d -m 0755 -o ${USER_NAME} -g ${USER_NAME} "/home/${USER_NAME}" \
	&& chown --changes --silent --no-dereference --recursive --from=33:33 \
		"${USER_ID}:${GROUP_ID}" "/home/${USER_NAME}"
USER ${USER_NAME}
WORKDIR /home/${USER_NAME}/project

# Dotfiles setup
RUN chezmoi init --apply --depth=1 --branch=${DOTFILES_BRANCH} ${DOTFILES_REPO}
