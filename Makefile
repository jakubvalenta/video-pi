_name := video-pi
_version := 1.2.1
_pkgrel := 1

_debian_src_filename := ${_name}_${_version}.orig.tar.xz
_debian_src_dirname := ${_name}-${_version}
_debian_pkg_filename := ${_name}_${_version}-${_pkgrel}_all.deb
_debian_container_name := video_pi_debian
_uid=$(shell id -u)
_gid=$(shell id -g)

dist_dir ?= dist

.PHONY: build
build:  ## Build
	CMAKE_EXPORT_COMPILE_COMMANDS=1 cmake -B build
	cp -a build/compile_commands.json compile_commands.json  # For clangd
	make -C build

.PHONY: install
install:  ## Install
	install -D -m644 -t "$(DESTDIR)/usr/bin" "$(DESTDIR)/build/video-pi-setup" bin/*
	install -D -m644 -t "$(DESTDIR)/etc" etc/*
	install -D -m644 -t "$(DESTDIR)/usr/share/applications" data/*.desktop
	install -D -m644 -t "$(DESTDIR)/usr/share/video-pi" data/*.svg
	install -D -m644 -t "$(DESTDIR)/etc/xdg/autostart" etc/xdg/autostart/video-pi-devmon.desktop

.PHONY: debian-build
debian-build:  ## Build a Debian package
	-rm -rf "$(dist_dir)"
	$(MAKE) "${dist_dir}/${_debian_pkg_filename}"

${dist_dir}/${_debian_pkg_filename}: ${dist_dir}/${_debian_src_dirname} | start-docker
	docker run --rm \
		-u "${_uid}:${_gid}" \
		-v "$$(pwd):/app" \
		-w "/app/${dist_dir}/${_debian_src_dirname}" \
		"$(_debian_container_name)" \
		debuild -us -uc

${dist_dir}/${_debian_src_dirname}: ${dist_dir}/${_debian_src_filename}
	cd "${dist_dir}" && tar xvf "${_debian_src_filename}"

${dist_dir}/${_debian_src_filename}:
	mkdir -p "${dist_dir}"
	tar cJvf "${dist_dir}/${_debian_src_filename}" \
		-X .tarignore \
		--transform 's,^\.,${_debian_src_dirname},' .

.PHONY: debian-sign
debian-sign: ${dist_dir}/${_debian_pkg_filename} | start-docker  ## Sign the Debian package
ifeq ($(key_id),)
	@echo "You must define the variable 'key_id'"
	exit 1
endif
	 # See https://nixaid.com/using-gpg-inside-a-docker-container/
	docker run --rm -it \
		-u "${_uid}:${_gid}" \
		-v "$$(pwd):/app" \
		-v "${HOME}/.gnupg/:/home/docker/.gnupg/:ro" \
		--tmpfs "/run/user/${_uid}/:mode=0700,uid=${_uid},gid=${_gid}" \
		-w "/app/${dist_dir}" \
		"$(_debian_container_name)" \
		sh -c 'gpg-agent --daemon && dpkg-sig -k "${key_id}" --sign builder "${_debian_pkg_filename}"'

.PHONY: debian-verify
debian-verify: ${dist_dir}/${_debian_pkg_filename} | start-docker  ## Verify the signature of the Debian package
	 # See https://nixaid.com/using-gpg-inside-a-docker-container/
	docker run --rm -it \
		-u "${_uid}:${_gid}" \
		-v "$$(pwd):/app:ro" \
		-v "${HOME}/.gnupg/:/home/docker/.gnupg/:ro" \
		--tmpfs "/run/user/${_uid}/:mode=0700,uid=${_uid},gid=${_gid}" \
		-w "/app/${dist_dir}" \
		"$(_debian_container_name)" \
		sh -c 'gpg-agent --daemon && dpkg-sig --verify "${_debian_pkg_filename}"'

.PHONY: debian-install
debian-install: ${dist_dir}/${_debian_pkg_filename}   ## Install the built Debian package
	sudo dpkg -i "${dist_dir}/${_debian_pkg_filename}"
	sudo apt-get install -f --yes

.PHONY: debian-build-udevil
debian-build-udevil: | start-docker  ## Build udevil
	docker run --rm \
		-u "${_uid}:${_gid}" \
		-v "$$(pwd):/app" \
		-w "/app" \
		"$(_debian_container_name)" \
		./build-udevil

.PHONY: debian-docker-build
debian-docker-build: | start-docker  ## Build the Docker container
	docker build -f debian/Dockerfile -t "$(_debian_container_name)" .

.PHONY: debian-docker-shell
debian-docker-shell: | start-docker  ## Run bash in the Docker container
	docker run --rm -it -u "${_uid}:${_gid}" -v "$$(pwd):/app" "$(_debian_container_name)" bash

.PHONY: start-docker
start-docker:
	docker info &> /dev/null || sudo systemctl start docker

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
