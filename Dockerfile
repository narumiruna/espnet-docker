FROM pytorch/pytorch:1.0.1-cuda10.0-cudnn7-devel

RUN apt-get update && apt-get install -y \
    cmake \
    libsndfile1-dev \
    wget \
    && rm -rf /var/lib/apt/lists/*

RUN pip install -U pip \
    && pip install \
    chainer==6.0.0 \
    configargparse \
    cupy==6.0.0 \
    editdistance==0.5.2 \
    funcsigs \
    g2p_en \
    git+https://github.com/kamo-naoyuki/pytorch_complex \
    git+https://github.com/nttcslab-sp/dnn_wpe \
    inflect \
    jaconv \
    kaldiio \
    nara_wpe \
    nltk \
    nnmnkwii \
    pillow-simd \
    pysptk \
    pyyaml \
    sentencepiece \
    soundfile \
    tensorboardX \
    unidecode \
    && rm -rf ~/.cache/pip

RUN conda install -c conda-forge \
    h5py=2.9.0 \
    kaldi \
    librosa \
    matplotlib \
    scipy \
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
