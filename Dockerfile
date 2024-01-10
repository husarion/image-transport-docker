ARG ROS_DISTRO=humble
ARG PREFIX=

FROM husarnet/ros:${PREFIX}${ROS_DISTRO}-ros-base AS pkg-builder

ARG ROS_DISTRO
ARG PREFIX

SHELL ["/bin/bash", "-c"]

RUN apt update && apt install -y \
        ros-humble-cv-bridge

RUN mkdir src && \
    git clone --depth 1 https://github.com/ros-misc-utilities/ffmpeg_image_transport.git src/ffmpeg_image_transport && \
    vcs import src < src/ffmpeg_image_transport/ffmpeg_image_transport.repos && \
    # without this line (using vulcanexus base image) rosdep init throws error: "ERROR: default sources list file already exists:"
    rm -rf /etc/ros/rosdep/sources.list.d/20-default.list && \
    rosdep init && \
    rosdep update --rosdistro $ROS_DISTRO && \
    rosdep install --from-paths src --ignore-src -y && \
    MYDISTRO=${PREFIX:-ros}; MYDISTRO=${MYDISTRO//-/} && \
    # source /opt/$MYDISTRO/$ROS_DISTRO/setup.bash && \
    source /opt/ros/$ROS_DISTRO/setup.bash && \
    colcon build --cmake-args -DCMAKE_BUILD_TYPE=Release  && \
    echo $(cat /ros2_ws/src/ffmpeg_image_transport/package.xml | grep '<version>' | sed -r 's/.*<version>([0-9]+.[0-9]+.[0-9]+)<\/version>/\1/g') >> /version.txt && \
    rm -rf build log

# =========================== final stage ===============================
FROM husarnet/ros:${PREFIX}${ROS_DISTRO}-ros-core

# Add architecture specific packages conditionally
ARG TARGETPLATFORM
RUN if [ "$TARGETPLATFORM" = "linux/arm64" ]; then \
        apt update && apt install -y libraspberrypi-bin; \
    fi

RUN apt update && apt install -y \
        ros-$ROS_DISTRO-image-geometry \
        ros-$ROS_DISTRO-image-publisher \
        ros-$ROS_DISTRO-image-transport \
        ros-$ROS_DISTRO-image-transport-plugins \
        ros-$ROS_DISTRO-tf2-ros \
        ffmpeg \
        ros-$ROS_DISTRO-cv-bridge && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN echo $(dpkg -s ros-${ROS_DISTRO}-image-transport | grep 'Version' | sed -r 's/Version:\s([0-9]+.[0-9]+.[0-9]+).*/\1/g') > /version.txt

COPY --from=pkg-builder /ros2_ws /ros2_ws
