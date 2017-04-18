PWD=$(shell readlink -m `pwd`)

FROM=$(shell grep FROM Dockerfile | sed 's/FROM //g')
PROJECT=$(shell basename `git rev-parse --show-toplevel`)

.PHONY: clean-build-test build
clean-build-test: clean build test
