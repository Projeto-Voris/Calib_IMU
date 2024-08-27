FROM ros:noetic
ARG bag_path=2024-08-22-12-57-43.bag

RUN apt-get update && DEBIAN_FRONTEND=noninteractive \
	apt-get install -y \
	git wget autoconf automake nano \
	python3-dev python3-pip python3-scipy python3-matplotlib \
	ipython3 python3-wxgtk4.0 python3-tk python3-igraph python3-pyx \
	libeigen3-dev libboost-all-dev libsuitesparse-dev \
	doxygen \
	libopencv-dev \
	libpoco-dev libtbb-dev libblas-dev liblapack-dev libv4l-dev \
	python3-catkin-tools python3-osrf-pycommon

##COPY /Home/Documents/Calibration/SALES 2024-08-22-12-57-43.bag
RUN mkdir /ws
WORKDIR /ws
RUN mkdir src
COPY SMALL.yaml SMALL.yaml
COPY ${bag_path} ${bag_path}
WORKDIR /ws/src
RUN git clone https://github.com/ori-drs/allan_variance_ros.git 
WORKDIR /ws
RUN /bin/bash -c "source /.bashrc;source /opt/ros/noetic/setup.bash; rosdep update; rosdep install --from-paths src --ignore-src -r -y ; catkin build allan_variance_ros"



RUN sudo catkin init
RUN rosdep update 
RUN rosdep install --from-paths src --ignore-src  -y
RUN sudo catkin config --extend /opt/ros/noetic 
RUN sudo catkin config --cmake-args -DCMAKE_BUILD_TYPE=Release
RUN sudo catkin build