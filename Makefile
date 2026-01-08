# Build the docker and add it :

setup:
	sudo docker build -t simker .
	xhost +local:docker
	xhost +local:root

run:
	sudo docker run -it --rm \
    		-v $(pwd):/project \
    		-w /project \
    		--net=host \
    		-e DISPLAY=$DISPLAY \
    		-v /tmp/.X11-unix:/tmp/.X11-unix \
    		simker
