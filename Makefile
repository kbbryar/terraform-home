.PHONY: build
build:
	podman image exists home-lab || podman build -t home-lab --squash-all .

.PHONY: run
run:
	podman run -it --privileged --name home-lab-container --mount type=bind,source="./.",target=/working home-lab;

.PHONY: stop
stop:
	podman container rm home-lab-container

.PHONY: clean
clean:
	podman image rm home-lab

.PHONY: keys
keys:
	rm -Rf ./keys/*
	ssh-keygen -t rsa -N "" -f ./keys/kubernetes
