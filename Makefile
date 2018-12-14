.PHONY: build

build:
	pack create-builder -b builder-riff.toml projectriff/builder

test:
	pushd integration-tests && go run main.go
