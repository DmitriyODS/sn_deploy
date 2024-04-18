.PHONY: release build back-build front-build back-push front-push up-db up-project down-db down-project


IMAGE_REPO=osipovskijdima
IMAGE_HOLA_BACK=$(IMAGE_REPO)/hola:b.$(shell cd sn_back && git describe --abbrev=0 --tags)

DOCKER_FLAGS =
dlog ?= 0

ifeq ($(dlog), 1)
    DOCKER_FLAGS += -d
endif

#all: release

up-db:
	docker compose -f ./compose-dev.yaml up $(DOCKER_FLAGS)

up-project:
	docker compose up $(DOCKER_FLAGS)

down-db:
	docker compose -f ./compose-dev.yaml down

down-project:
	docker compose down

release: back-build front-build back-push front-push

build: back-build front-build

back-build:
	@echo "start making image" $(IMAGE_HOLA_BACK)
	docker build -f ./service.Dockerfile -t $(IMAGE_HOLA_BACK) .
	@echo "finish making image" $(IMAGE_HOLA_BACK)

front-build:
	@echo "start making image" $(IMAGE_HOLA_FRONT)
	docker build --build-arg base_url=kodass.ru --build-arg base_port=8080 --build-arg base_api=v1 -f ./client.Dockerfile -t $(IMAGE_HOLA_FRONT) .
	@echo "finish making image" $(IMAGE_HOLA_FRONT)

back-push:
	@docker push $(IMAGE_HOLA_BACK)

front-push:
	@docker push $(IMAGE_HOLA_FRONT)
