FROM nvidia/cuda:9.0-devel-ubuntu16.04

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    git \
    libfontconfig1 libxrender1 \
    libsm6 libxext6   libglu1-mesa \
    ca-certificates \
  && rm -rf /var/lib/apt/lists/*

RUN curl -qsSLkO \
    https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-`uname -p`.sh \
  && bash Miniconda3-latest-Linux-`uname -p`.sh -b \
  && rm Miniconda3-latest-Linux-`uname -p`.sh

ENV PATH=/root/miniconda3/bin:$PATH

RUN curl -qsSLkO https://raw.githubusercontent.com/fastai/fastai/master/environment.yml \
    && conda update -y conda && conda env update -n root


RUN conda install -y \
    h5py \
    pandas \
    theano \
  && conda clean --yes --tarballs --packages --source-cache \
  && pip install --upgrade -I setuptools \
  && pip install --upgrade \
    keras future \
    https://storage.googleapis.com/tensorflow/linux/gpu/tensorflow_gpu-1.5.0-cp36-cp36m-linux_x86_64.whl



ENV LD_LIBRARY_PATH=/root/miniconda3/lib/:/usr/local/cuda:/usr/local/cuda/lib64:/usr/local/cuda/lib64/stubs

RUN ln -s /usr/local/cuda/lib64/stubs/libcuda.so /usr/local/cuda/lib64/stubs/libcuda.so.1



VOLUME /notebook
WORKDIR /notebook
EXPOSE 8888

CMD jupyter notebook --no-browser --ip=0.0.0.0 --allow-root --NotebookApp.token=
