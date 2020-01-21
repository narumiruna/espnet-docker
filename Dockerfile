FROM pytorch/pytorch:1.4-cuda10.1-cudnn7-devel

RUN apt-get update && apt-get install -y \
    cmake \
    libsndfile1-dev \
    wget \
    && rm -rf /var/lib/apt/lists/*

RUN pip install -U pip \
    && pip install cupy==6.7.0 kaldiio \
    && rm -rf ~/.cache/pip

RUN conda install chainer matplotlib \
    && conda install -c conda-forge kaldi \
    && conda clean -ya

# Install chainer_ctc
WORKDIR /opt
RUN git clone https://github.com/jheymann85/chainer_ctc.git \
    && cd chainer_ctc \
    && bash install_warp-ctc.sh \
    && pip install .

# Install warp-ctc
RUN git clone https://github.com/espnet/warp-ctc \
    && mkdir -p warp-ctc/build \
    && cd warp-ctc/build \
    && cmake .. \
    && make -j$(nproc) \
    && cd ../pytorch_binding \
    && python setup.py install

# Install warprnnt_pytorch
RUN git clone https://github.com/HawkAaron/warp-transducer.git \
    && mkdir -p warp-transducer/build \
    && cd warp-transducer/build \
    && cmake .. \
    && make -j$(nproc) \
    && cd ../pytorch_binding \
    && python setup.py install

# Install ESPnet
WORKDIR /workspace
RUN git clone https://github.com/espnet/espnet.git \
    && cd espnet \
    && git checkout v.0.6.1 \
    && pip install .

WORKDIR /workspace/espnet/tools
