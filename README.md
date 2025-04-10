# DeepStream-YOLOv11 Integration

This repo helps you deploy YOLOv11 with NVIDIA DeepStream 7.1 using the official NGC container.

## Structure
```
deepstream_yolov11/
├── Dockerfile
├── setup.sh
├── deepstream_app_config.txt
├── config_infer_primary_yoloV11.txt
└── weights/
    └── yolo11s.pt  # You need to place this file manually
```

## Usage

1. Clone repo and place `yolo11s.pt` inside the `weights/` folder.
2. Build container:
   ```bash
   docker build -t deepstream-yolov11 .
   ```
3. Run it:
   ```bash
   xhost +local:root
   docker run --gpus all -it --net=host --runtime=nvidia \
     -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix \
     -v $(pwd):/workspace deepstream-yolov11
   ```
4. Inside container:
   ```bash
   ./setup.sh
   deepstream-app -c deepstream_app_config.txt
   ```
