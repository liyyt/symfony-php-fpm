src = $(wildcard Dockerfile.*)
builds = $(subst Dockerfile.,,$(src))
clean_builds = $(subst Dockerfile.,clean_,$(src))
clean_all_builds = $(subst Dockerfile.,cleanall_,$(src))
push_builds = $(subst Dockerfile.,push_,$(src))

ACCOUNT ?= liyyt
PROJECT ?= symfony
VERSION ?= latest

.PHONY: all $(src)
all: $(subst Dockerfile.,,$@) $(builds)
$(builds):
	-docker build -f Dockerfile.$@ --pull --tag $(ACCOUNT)/$(PROJECT)-$@:$(VERSION) .

.PHONY: clean $(src)
clean: $(subst Dockerfile.,,$@) $(clean_builds)
$(clean_builds):
	-@docker rmi $(ACCOUNT)/$(subst clean_,$(PROJECT)-,$@):$(VERSION)

.PHONY: cleanall $(src)
cleanall: $(subst Dockerfile.,,$@) $(clean_all_builds)
$(clean_all_builds):
	-@grep -Eo "^FROM\s([a-z0-9\/\:_-]+)" $(subst cleanall_,Dockerfile.,$@) | grep -Eo "([a-z0-9\/\:_-]+)" | xargs -I % sh -c 'docker rmi %;'
	-@docker rmi $(ACCOUNT)/$(subst cleanall_,$(PROJECT)-,$@):$(VERSION)

.PHONY: push $(src)
push: $(subst Dockerfile.,,$@) $(push_builds)
$(push_builds):
	-@docker push $(ACCOUNT)/$(subst push_,$(PROJECT)-,$@):$(VERSION)
