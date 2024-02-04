VERSION=$(shell git rev-parse HEAD)
IMAGE = docker.io/helenfrank/dev-env
build-image:
	@docker build -t ${IMAGE}:${VERSION} .
	@docker tag ${IMAGE}:${VERSION} ${IMAGE}:latest

push-image:
	@docker push ${IMAGE}:${VERSION}
	@docker push ${IMAGE}:latest

all: build-image push-image
