ROOT_DIR	:= $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

all:
	@echo 'Available make targets:'
	@grep '^[^#[:space:]^\.PHONY.*].*:' Makefile

.PHONY: setup
setup: 
	@echo 'Pulling submodules for forked themes'
	git submodule update --init --recursive -j 8
	git pull --recurse-submodules

.PHONY: clean
clean:
	@echo 'Blowing away old builds'
	rm -rf public/*

.PHONY: preview
preview:
	hugo server -D
	@echo 'The site is now being served at http://localhost:1313'

.PHONY: build
build: clean setup
	cd public && git checkout master
	hugo -D
	@echo 'The site is now ready to deploy within /public.'

.PHONY: deploy
deploy: build
	@echo 'Attempting a deploy to master'
	cp CNAME public/
	cp README.md public/
	cp favicon.ico public/
	cd public && git add -A
	cd public &&  git commit -m 'Hugo site updated content.  See gh-pages branch for detailed info'
	cd public && git push origin master
	@echo 'deploy complete to master branch'
