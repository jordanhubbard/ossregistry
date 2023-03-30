# Simple wrapper makefile to make local setup and execution easy as well
# as build + run this in a docker container.

DOCKER_IMAGE_NAME=ossregistry
INIT_SENTINEL=_build/.init_run

all: run

docker:
	docker build . -t ${DOCKER_IMAGE_NAME}
	env SECRET_KEY_BASE=`mix phx.gen.secret` DATABASE_URL=ecto://postgres:PASS@HOST/database 
	docker run ${DOCKER_IMAGE_NAME} mix phx.server

init:
	@if [ ! -f ${INIT_SENTINEL} ]; then \
	  if which mix > /dev/null; then \
		mix local.hex --force; \
		mix local.rebar --force; \
		mix deps.get; \
		mix ecto.create; \
		mix setup; \
	  else \
		echo "You must first install elixir package"; \
		exit 1; \
	  fi; \
	  touch ${INIT_SENTINEL}; \
	fi

build: init
	mix deps.get

run: build
	mix phx.server

clean:
	rm -rf _build
