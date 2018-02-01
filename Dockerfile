FROM ubuntu

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    git \
    ca-certificates \
  && rm -rf /var/lib/apt/lists/*

RUN curl -qsSLkO \
    https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-`uname -p`.sh \
  && bash Miniconda3-latest-Linux-`uname -p`.sh -b \
  && rm Miniconda3-latest-Linux-`uname -p`.sh

ENV PATH=/root/miniconda3/bin:$PATH

RUN curl -qsSLkO https://raw.githubusercontent.com/fastai/fastai/master/environment.yml \
    && conda env update


VOLUME /notebook
WORKDIR /notebook
EXPOSE 8888

ENV CONDA_DEFAULT_ENV fastai
ENV CONDA_PREFIX /root/miniconda3/envs/fastai
ENV PATH=/root/miniconda3/envs/bin/:$PATH


RUN conda install -y \
    h5py \
    pandas \
    theano \
  && conda clean --yes --tarballs --packages --source-cache \
  && pip install --upgrade -I setuptools \
  && pip install --upgrade \
    keras future \
    https://storage.googleapis.com/tensorflow/linux/gpu/tensorflow_gpu-1.5.0-cp36-cp36m-linux_x86_64.whl

CMD source activate fastai && jupyter notebook --no-browser --ip=0.0.0.0 --allow-root --NotebookApp.token=
