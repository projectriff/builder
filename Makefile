PACK ?= pack
BUILDER ?= projectriff/builder:dev-$(shell cat builder.toml | md5)

.PHONY: build test

build:
	$(PACK) create-builder -b builder.toml $(BUILDER)

test:
	BUILDER=$(BUILDER) go test -v -tags=acceptance -count=1 ./acceptance
