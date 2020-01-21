build:
	docker build -f Dockerfile -t narumi/espnet .

run:
	docker run -it --rm narumi/espnet
