clean:
	 docker rmi -f $$( docker images | grep '^$(PROJECT) '| awk '{print $$3;}') || true

build:
	 docker pull $(FROM)
	 docker build -t $(PROJECT) .
	 docker history $(PROJECT)

shell:
	docker run --rm -v $(PWD)/build:/srv/npcgrinder/build --entrypoint /bin/bash -it $(PROJECT)

run:
	docker run -v $(PWD)/build:/srv/npcgrinder/build --rm -it $(PROJECT)

out:
	@cat build/out.html
