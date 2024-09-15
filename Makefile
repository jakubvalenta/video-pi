_name := video-pi
_version := 1.2.1
_pkgrel := 1

_video_pi_pkg_filename := $(_name)_$(_version)-$(_pkgrel)_armhf.deb
_video_pi_pkg_src_filename := $(_name)_$(_version).orig.tar.xz
_video_pi_pkg_src_dirname := $(_name)-$(_version)
_udevil_pkg_filename := udevil_0.4.5-2_armhf.deb

_container_name := video_pi_debian
_uid=$(shell id -u)
_gid=$(shell id -g)

dist_dir ?= dist

.PHONY: build
build:  ## Build
	CMAKE_EXPORT_COMPILE_COMMANDS=1 cmake -B build
	-cp -a build/compile_commands.json compile_commands.json  # For clangd
	make -C build

.PHONY: install
install:  ## Install
	install -D -m644 -t "$(DESTDIR)/etc/video-pi" etc/video-pi.fdignore etc/video-pi.sh
	install -D -m644 -t "$(DESTDIR)/etc/xdg/autostart" etc/xdg/autostart/video-pi-devmon.desktop
	install -D -m644 -t "$(DESTDIR)/usr/bin" bin/video-pi-devmon bin/video-pi-play build/video-pi-install build/video-pi-uninstall
	install -D -m644 -t "$(DESTDIR)/usr/share/video-pi" usr/share/video-pi/panel

.PHONY: docker-build-video-pi
docker-build-video-pi: | $(dist_dir) docker-start check-key-id  ## Build the video-pi package in Docker
	rm -f "$(dist_dir)/$(_video_pi_pkg_src_filename)" && \
		tar -cJvf "$(dist_dir)/$(_video_pi_pkg_src_filename)" \
			-X .tarignore \
			--transform 's,^\.,$(_video_pi_pkg_src_dirname),' .
	cd "$(dist_dir)" && \
		rm -rf "$(_video_pi_pkg_src_dirname)" && \
		tar -xvf "$(_video_pi_pkg_src_filename)"
	make docker-run cmd="sh -c '\
		cd \"$(dist_dir)\" && \
		rm -f "$(_video_pi_pkg_filename)" && \
		(cd \"$(_video_pi_pkg_src_dirname)\" && debuild -us -uc) && \
		gpg-agent --daemon && \
		dpkg-sig -k \"$(key_id)\" --sign builder \"$(_video_pi_pkg_filename)\" && \
		dpkg-sig --verify \"$(_video_pi_pkg_filename)\"'"

.PHONY: docker-build-udevil
docker-build-udevil: | $(dist_dir) docker-start check-key-id  ## Build the udevil package in Docker
	wget -O "$(dist_dir)/udevil.tar.gz" "https://github.com/IgnorantGuru/udevil/tarball/next"
	cd "$(dist_dir)" && \
		rm -rf "IgnorantGuru-udevil-*" && \
		tar -xzf udevil.tar.gz
	cd "$(dist_dir)" && \
		rm -rf "udevil-0.4.5" && \
		mv IgnorantGuru-udevil-* "udevil-0.4.5"
	cd "$(dist_dir)/udevil-0.4.5" && ln -s distros/debian debian
	cp -t "$(dist_dir)/udevil-0.4.5" udevil/fix_exfat_nonempty.patch
	cd "$(dist_dir)/udevil-0.4.5" && patch -p1 < fix_exfat_nonempty.patch
	make docker-run cmd="sh -c '\
		cd \"$(dist_dir)/udevil-0.4.5\" && \
		export DEBFULLNAME=\"Jakub Valenta\" && \
		export DEBEMAIL=\"jakub@jakubvalenta.cz\" && \
		dch -v 0.4.5-2 \"Fix exfat support (remove default option nonempty).\" && \
		dpkg-buildpackage -us -uc -nc && \
		cd .. && \
		gpg-agent --daemon && \
		dpkg-sig -k \"$(key_id)\" --sign builder \"$(_udevil_pkg_filename)\" && \
		dpkg-sig --verify \"$(_udevil_pkg_filename)\"'"

$(dist_dir):
	mkdir -p "$@"

.PHONY: docker-image
docker-image: | docker-start  ## Build the Docker image
	docker build --platform linux/arm/v7 -f debian/Dockerfile -t "$(_container_name)" .

.PHONY: docker-shell
docker-shell: | docker-start  ## Run bash in Docker
	$(MAKE) docker-run cmd="bash"

.PHONY: docker-run
docker-run:
	 # See https://nixaid.com/using-gpg-inside-a-docker-container/
	docker run --platform linux/arm/v7 --rm -it \
		-u "$(_uid):$(_gid)" \
		-v "$$(pwd):/app" \
		-v "$(HOME)/.gnupg/:/home/docker/.gnupg/:ro" \
		--tmpfs "/run/user/${_uid}/:mode=0700,uid=${_uid},gid=${_gid}" \
		"$(_container_name)" $(cmd)

.PHONY: docker-start
docker-start:
	docker info &> /dev/null || sudo systemctl start docker

.PHONY: check-key-id
check-key-id:
ifeq ($(key_id),)
	@echo "You must set the variable 'key_id'."
	exit 1
endif

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
