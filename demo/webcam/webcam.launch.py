from launch import LaunchDescription
from launch_ros.actions import Node
from launch.actions import DeclareLaunchArgument
from launch.substitutions import LaunchConfiguration, ThisLaunchFileDir
from launch.conditions import IfCondition, UnlessCondition
from launch.substitutions import TextSubstitution

def generate_launch_description():
    # Declare launch arguments
    video_device_arg = DeclareLaunchArgument(
        'video_device', default_value='/dev/video0',
        description='Video device path')

    pixel_format_arg = DeclareLaunchArgument(
        'pixel_format', default_value='YUYV',
        description='Pixel format')

    output_encoding_arg = DeclareLaunchArgument(
        'output_encoding', default_value='yuv422_yuy2',
        description='Output encoding')

    image_size_arg = DeclareLaunchArgument(
        'image_size', default_value='[640, 480]',
        description='Image size')

    camera_frame_id_arg = DeclareLaunchArgument(
        'camera_frame_id', default_value='camera_optical_link',
        description='Camera frame ID')

    params_file_arg = DeclareLaunchArgument(
        'params_file', default_value='',
        description='Path to the parameters file')

    device_namespace_arg = DeclareLaunchArgument(
        'device_namespace', default_value='camera',
        description='Device namespace')

    ffmpeg_encoding_arg = DeclareLaunchArgument(
        'ffmpeg_encoding', default_value='libx264',
        description='FFMPEG encoding')

    ffmpeg_preset_arg = DeclareLaunchArgument(
        'ffmpeg_preset', default_value='ultrafast',
        description='FFMPEG preset')

    ffmpeg_tune_arg = DeclareLaunchArgument(
        'ffmpeg_tune', default_value='zerolatency',
        description='FFMPEG tune')

    # v4l2_camera node configuration
    v4l2_camera_node = Node(
        package='v4l2_camera',
        executable='v4l2_camera_node',
        name='camera',
        namespace=LaunchConfiguration('device_namespace'),
        parameters=[
            {
                'video_device': LaunchConfiguration('video_device'),
                'pixel_format': LaunchConfiguration('pixel_format'),
                'output_encoding': LaunchConfiguration('output_encoding'),
                'image_size': LaunchConfiguration('image_size'),
                'camera_frame_id': LaunchConfiguration('camera_frame_id'),
                'camera_name': LaunchConfiguration('device_namespace'),
                'camera_link_frame_id': [LaunchConfiguration('device_namespace'), TextSubstitution(text='_link')],
                'ffmpeg_image_transport.encoding': LaunchConfiguration('ffmpeg_encoding'),
                'ffmpeg_image_transport.preset': LaunchConfiguration('ffmpeg_preset'),
                'ffmpeg_image_transport.tune': LaunchConfiguration('ffmpeg_tune'),
            },
            LaunchConfiguration('params_file')
        ],
        # Add any necessary remappings here
    )

    # Assemble the launch description
    return LaunchDescription([
        video_device_arg,
        pixel_format_arg,
        output_encoding_arg,
        image_size_arg,
        camera_frame_id_arg,
        params_file_arg,
        device_namespace_arg,
        ffmpeg_encoding_arg,
        ffmpeg_preset_arg,
        ffmpeg_tune_arg,
        v4l2_camera_node
    ])

