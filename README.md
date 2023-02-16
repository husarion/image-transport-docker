# image-transport-docker

Dockerized [`image_transport`](https://index.ros.org/p/image_transport/) ROS 2 package based on fork with default QOS reliability changed to `best_effort`.

## Usage

### compress

```yaml
  image_compressor:
    image: husarion/image-transport:humble
    <<: *net-config
    command: >
      ros2 run image_transport republish raw ${CODEC:-theora}
        --ros-args
        --remap in:=/camera/color/image_raw
        --remap out/${CODEC:-theora}:=/camera/color/image_raw/${CODEC:-theora}
    # --params-file /image_transport_params.yaml
```

### decompress

```yaml
  image_decompressor:
    image: husarion/image-transport:humble
    <<: *net-config
    command: >
      ros2 run image_transport republish ${CODEC:-theora} raw
      --ros-args
      --remap in/${CODEC:-theora}:=/camera/color/image_raw/${CODEC:-theora}
      --remap out:=/camera/my_image_raw
    # --params-file /image_transport_params.yaml
```
