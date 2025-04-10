FROM nvcr.io/nvidia/deepstream:7.1-triton-multiarch

WORKDIR /workspace

RUN apt update && apt install -y python3-pip git wget
RUN pip3 install torch torchvision --index-url https://download.pytorch.org/whl/cu118 \
    && pip3 install git+https://github.com/ultralytics/ultralytics.git

RUN git clone https://github.com/marcoslucianops/DeepStream-Yolo.git

WORKDIR /workspace/DeepStream-Yolo/nvdsinfer_custom_impl_Yolo
RUN export CUDA_VER=12.3 && make

WORKDIR /workspace
