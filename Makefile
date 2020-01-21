build:
	docker build -f Dockerfile -t narumi/espnet .

run:
	docker run -it --rm --gpus all narumi/espnet
