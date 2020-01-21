FROM pytorch/pytorch:1.4-cuda10.1-cudnn7-devel

RUN apt-get update && apt-get install -y \
    cmake \
    wget \
    && rm -rf /var/lib/apt/lists/*

RUN pip install -U pip \
    && pip install kaldiio \
    && rm -rf ~/.cache/pip

RUN conda install chainer matplotlib \
    && conda install -c conda-forge kaldi \
    && conda clean -ya

# Install chainer_ctc
WORKDIR /tmp
RUN git clone https://github.com/jheymann85/chainer_ctc.git \
    && cd chainer_ctc \
    && bash install_warp-ctc.sh \
    && pip install . \
    && cd .. \
    && rm -rf chainer_ctc

# Install warp-ctc
RUN git clone https://github.com/espnet/warp-ctc \
    && mkdir -p warp-ctc/build \
    && cd warp-ctc/build \
    && cmake .. \
    && make -j$(nproc) \
    && cd ../pytorch_binding \
    && python setup.py install \
    && cd ../../ \
    && rm -rf warp-ctc

WORKDIR /workspace
RUN git clone https://github.com/espnet/espnet.git
RUN cd espnet \
    && git checkout v.0.7.0 \
    && pip install .

WORKDIR /workspace/espnet/tools
