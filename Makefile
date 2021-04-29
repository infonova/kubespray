GIT_SHA := $(shell echo `git rev-parse --verify HEAD^{commit}`)
IMAGE_TAG ?= ${GIT_SHA}
IMAGE_REPO_NAME ?= quay.io/kubespray
IMAGE_NAME := ${IMAGE_REPO_NAME}/kubespray:${IMAGE_TAG}
BUILD_KUBE_VERSION ?= v1.19.10

default: mitogen clean

mitogen:
	ansible-playbook -c local mitogen.yml -vv
clean:
	rm -rf dist/
	rm *.retry

build-image:
	docker build --build-arg "BUILD_KUBE_VERSION=${BUILD_KUBE_VERSION}" -t ${IMAGE_NAME} .
