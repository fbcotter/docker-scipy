# Dockerfile with tensorflow gpu support on python3
FROM tensorflow/tensorflow:1.5.0-devel-gpu-py3

MAINTAINER Fergal Cotter <fbc23@cam.ac.uk>

# The code below is all based off the repos made by https://github.com/janza/
# He makes great dockerfiles for opencv, I just used a different base as I need
# tensorflow on a gpu.

RUN apt-get update

# Core linux dependencies. 
RUN apt-get install -y \
        build-essential \
        cmake \
        git \
        wget \
        unzip \
        yasm \
        pkg-config \
        ssh \
        python3-tk

# Python dependencies
RUN pip3 --no-cache-dir install \
    numpy \
    hdf5storage \
    h5py \
    scipy \
    py3nvml \
    jupyter_contrib_nbextensions \
    sklearn \
	scikit-image

# Install Pytorch
# RUN pip install http://download.pytorch.org/whl/cu80/torch-0.3.0.post4-cp35-cp35m-linux_x86_64.whl
# RUN pip install torchvision

# Install some jupyter notebook niceties.
RUN jupyter contrib nbextension install
RUN git clone https://github.com/minrk/nbextension-scratchpad \
    && jupyter nbextension install nbextension-scratchpad
RUN pip install jupyter-tensorboard
RUN jupyter nbextension enable nbextension-scratchpad/main
RUN jupyter nbextension enable execute_time/ExecuteTime
RUN jupyter nbextension enable --py widgetsnbextension
RUN mkdir -p /root/.jupyter/custom
COPY jupyter-custom.css /root/.jupyter/custom/custom.css

# Some code repos to use
RUN mkdir -p /root/.ssh
RUN ssh-keyscan github.com >> /root/.ssh/known_hosts
RUN pip3 install git+https://github.com/fbcotter/dtcwt.git@0.13.1dev1#egg=dtcwt
RUN pip3 install git+https://github.com/fbcotter/dtcwt_slim.git@0.1.0rc1#egg=dtcwt_slim
RUN pip3 install git+https://github.com/fbcotter/plotters.git@0.0.6#egg=plotters
RUN pip3 install git+https://github.com/fbcotter/dataset_loading.git@0.0.3#egg=dataset_loading
RUN pip3 install git+https://github.com/fbcotter/tf_ops.git@0.1.1#egg=tf_ops

WORKDIR /host/repos
