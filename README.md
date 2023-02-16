# image-transport-docker

Dockerized [`image_transport`](https://index.ros.org/p/image_transport/) ROS 2 package based on fork with default QOS reliability changed to `best_effort`.

## Usage

```yaml
  image_transport:
    image: husarion/image-transport:humble
    command: >
      ros2 run image_transport republish raw compressed
        --ros-args
        --remap in:=/camera/color/image_raw
        --remap out/compressed:=/camera/color/image_raw/compressed
    # --params-file /image_transport_params.yaml
```