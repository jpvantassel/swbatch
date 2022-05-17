FROM jpvantassel/geopsy-docker:3.4.2-qt5.14

LABEL IMAGE_NAME="jpvantassel/swbatch:0.4.0"
LABEL IMAGE_NAME_ALT="jpvantassel/swbatch:geopsy-v3.4.2"
LABEL MAINTAINER="Joseph P. Vantassel <joseph.p.vantassel@gmail.com>"

RUN sudo apt update \
 && sudo apt upgrade --yes \
 && sudo apt install --yes --quiet --no-install-recommends \
   python3 \
   python3-pip \
 && sudo apt clean

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

SHELL ["/bin/bash", "-ec"]

ADD requirements.txt /home/user/

RUN python3 -m pip install virtualenv \
 && python3 -m virtualenv /home/user/venv \ 
 && source /home/user/venv/bin/activate \
 && pip install -r /home/user/requirements.txt \
 && rm /home/user/requirements.txt \
 && mkdir /home/user/analysis/

ADD swbatch.py /home/user/

WORKDIR /home/user/

CMD ["python3", "/home/user/analysis/swbatch.py", "--help"]
