#!/bin/bash

set -e
cd /workspace

mkdir -p weights
cp /workspace/weights/yolo11s.pt weights/

cd DeepStream-Yolo
python3 utils/export_yoloV8.py -w ../weights/yolo11s.pt --dynamic

trtexec --onnx=yolo11s.onnx --saveEngine=yolo11s_b1_gpu0_fp16.engine --fp16

mv yolo11s.onnx /workspace/
mv yolo11s_b1_gpu0_fp16.engine /workspace/
