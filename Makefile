GIT_SHA := $(shell echo `git rev-parse --verify HEAD^{commit}`)
IMAGE_TAG ?= ${GIT_SHA}
IMAGE_REPO_NAME ?= quay.io/kubespray
IMAGE_NAME := ${IMAGE_REPO_NAME}/kubespray:${IMAGE_TAG}
KUBE_VERSION ?= $(shell sed -n 's/^kube_version: //p' roles/kubespray-defaults/defaults/main.yaml)

default: mitogen clean

mitogen:
	ansible-playbook -c local mitogen.yml -vv
clean:
	rm -rf dist/
	rm *.retry

build-image:
	docker build --build-arg "KUBE_VERSION=$(KUBE_VERSION)" -t ${IMAGE_NAME} .
