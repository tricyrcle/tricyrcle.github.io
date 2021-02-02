ROOT_DIR	:= $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

all:
	@echo 'Available make targets:'
	@grep '^[^#[:space:]^\.PHONY.*].*:' Makefile

.PHONY: setup
setup: 
	@echo 'Pulling submodules for forked themes'
	mkdir -p public/
	mkdir -p themes/
	git clone git@github.com:tricyrcle/meghna-hugo.git themes/meghna-hugo

.PHONY: clean
clean:
	@echo 'Blowing away old builds'
	rm -rf public/*
	rm -rf themes/

.PHONY: preview
preview: setup
	hugo server -D --themesDir=themes/
	@echo 'The site is now being served at http://localhost:1313'

.PHONY: build
build: clean setup
	cd public && git checkout main
	hugo -D --themesDir=themes/
	@echo 'The site is now ready to deploy within /public.'

.PHONY: deploy
deploy: build
	@echo 'Attempting a deploy to main'
	# cp CNAME public/
	cp README.md public/
	# cp favicon.ico public/
	cd public && git add -A
	cd public &&  git commit -m 'Hugo site updated content.  See gh-pages branch for detailed info'
	cd public && git push origin main
	@echo 'deploy complete to main branch'
