PROJECT := loglet
RELEASE_PLATFORMS := linux_amd64

GO=GO111MODULE=on go
MAIN=./cmd/$(PROJECT)/main.go

CODE_VERSION=$(shell git rev-parse --short HEAD)
ifeq ($(TRAVIS_COMMIT),)
	CODE_VERSION=$(shell git rev-parse --short HEAD)-dev
endif

.PHONY: release $(RELEASE_PLATFORMS) test

test:
	$(GO) test -v

$(RELEASE_PLATFORMS):
	CGO_ENABLED=0 \
	GOOS=$(word 1, $(subst _, ,$@)) GOARCH=$(word 2, $(subst _, ,$@)) \
	$(GO) build -v -i -o $(PROJECT) $(MAIN) && \
		tar -czvf $(PROJECT)-$(CODE_VERSION)-$@.tar.gz $(PROJECT) && \
		rm $(PROJECT)

release: $(RELEASE_PLATFORMS)
