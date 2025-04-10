#  Deploy YOLOv11 with NVIDIA DeepStream 7.1

This repository enables real-time object detection using **YOLOv11** integrated into the **NVIDIA DeepStream SDK (7.1)** via the official container from **NGC (NVIDIA GPU Cloud)**.

---

## 📦 Project Structure

```
deepstream_yolov11/
├── Dockerfile                            # Docker container setup based on DeepStream 7.1
├── setup.sh                              # Script to export YOLOv11 to ONNX and generate TRT engine
├── deepstream_app_config.txt             # DeepStream application pipeline config
├── config_infer_primary_yoloV11.txt      # YOLOv11 model configuration for DeepStream inference
├── weights/
│   └── yolo11s.pt                        # 🔁 Place your YOLOv11 PyTorch model weights here manually
└── README.md                             # This file
```

---

##  Objective

- Convert **YOLOv11** PyTorch model to **ONNX**
- Integrate into **DeepStream 7.1 pipeline**
- Run object detection on video using optimized **TensorRT engine**

---

##  Requirements

- NVIDIA GPU with drivers installed
- [Docker](https://docs.docker.com/engine/install/)
- [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html)
- Linux system (tested on Ubuntu 22.04)
- Model weights: `yolo11s.pt` from [Ultralytics](https://github.com/ultralytics/ultralytics)

---

##  Setup Instructions

### 1. Clone This Repo

```bash
git clone https://github.com/T-DevH/deepstream_yolov11.git
cd deepstream_yolov11
```

---

### 2. Place Model Weights

Manually download `yolo11s.pt` from the official [Ultralytics release page](https://github.com/ultralytics/assets/releases/) and place it in the `weights/` folder:

```bash
mv ~/Downloads/yolo11s.pt weights/
```

---

### 3. Build the Docker Container

```bash
docker build -t deepstream-yolov11 .
```

---

### 4. Run the Container

> Allows GUI video display by forwarding X11 and mounting video source

```bash
xhost +local:root

docker run --gpus all -it --rm   --net=host   --runtime=nvidia   -e DISPLAY=$DISPLAY   -v /tmp/.X11-unix:/tmp/.X11-unix   -v $(pwd):/workspace   deepstream-yolov11
```

---

### 5. Inside the Container

Run the setup script to:
- Export `yolo11s.pt` → `ONNX`
- Build a TensorRT `.engine`
- Prepare DeepStream inference pipeline

```bash
./setup.sh
```

---

### 6. Run DeepStream Application

```bash
deepstream-app -c deepstream_app_config.txt
```

You should see real-time object detection running on the provided video (edit `deepstream_app_config.txt` to change video source).

---

###  How `DeepStream-Yolo` Is Used

This project integrates with the excellent [DeepStream-Yolo](https://github.com/marcoslucianops/DeepStream-Yolo) project to:

- ✅ Export YOLOv11 models from PyTorch to ONNX using `utils/export_yoloV8.py`
- ✅ Compile a custom DeepStream plugin `libnvdsinfer_custom_impl_Yolo.so` to parse YOLO outputs
- ✅ Reuse tried-and-tested configuration formats for DeepStream compatibility

These steps are handled automatically:
- The repository is cloned in the Dockerfile.
- The plugin is compiled during container build.
- The ONNX export is performed in `setup.sh`.
- The `.so` plugin is referenced inside `config_infer_primary_yoloV11.txt`.

 No manual steps are needed — everything is automated within the Docker container.

---

##  License

This project uses open-source components under their respective licenses (YOLO, DeepStream, Ultralytics).

---

##  Acknowledgements

- [Ultralytics](https://github.com/ultralytics/ultralytics)
- [NVIDIA DeepStream SDK](https://developer.nvidia.com/deepstream-sdk)
- [MarcosLuciano’s DeepStream-Yolo](https://github.com/marcoslucianops/DeepStream-Yolo)

---

##  Need Help?

Feel free to open an issue or reach out if you need help with DeepStream, YOLO export, or pipeline tuning!
