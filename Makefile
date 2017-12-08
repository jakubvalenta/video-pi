.PHONY: erase build build-continue install checkargs help

erase: checkargs  ## Overwrite the whole DEVICE with zeros.
	sudo dd if=/dev/zero of=$(DEVICE) iflag=nocache oflag=direct bs=4M status=progress

build:  ## Build the image
	sudo systemctl start docker
	./fix-loopback.sh
	./build-docker.sh

build-continue:  ## Continue building the image (if previous build failed)
	./fix-loopback.sh
	CONTINUE=1 $(MAKE) build

install: checkargs  ## Install built image
	unzip -p deploy/image_2017-12-08-VideoPi-standard.zip | sudo dd of=$(DEVICE) bs=4 status=progress conv=fsync
	sudo sync

checkargs:
ifeq (,$(DEVICE))
	@echo "You must set the DEVICE variable."
	@echo "Example: make backup DEVICE=/dev/sdX"
	@exit 1
endif

help: # https://gist.github.com/jhermsmeier/2d831eb8ad2fb0803091
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-14s\033[0m %s\n", $$1, $$2}'
