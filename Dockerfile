ARG ROS_DISTRO=humble

FROM husarnet/ros:$ROS_DISTRO-ros-base

SHELL ["/bin/bash", "-c"]

RUN git clone -b rolling https://github.com/DominikN/image_common/ src/image_common && \
    git clone -b 2.6.0 https://github.com/ros-perception/image_transport_plugins src/image_transport_plugins && \
    . /opt/ros/$ROS_DISTRO/setup.sh && \
    apt update && \
    rosdep update --rosdistro $ROS_DISTRO && \
    rosdep install --from-paths src --ignore-src -y && \
    colcon build && \
    echo $(cat /ros2_ws/src/image_common/image_transport/package.xml | grep '<version>' | sed -r 's/.*<version>([0-9]+.[0-9]+.[0-9]+)<\/version>/\1/g') > /version.txt && \
    rm -rf log/ build/ src/* && \
    rm -rf /var/lib/apt/lists/*