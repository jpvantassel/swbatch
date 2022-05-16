FROM jpvantassel/geopsy-docker:2.10.1-qt4.8

LABEL IMAGE_NAME="jpvantassel/swbatch:0.3.1"
LABEL IMAGE_NAME_ALT="jpvantassel/swbatch:geopsy-v2.10.1"
LABEL MAINTAINER="Joseph P. Vantassel <joseph.p.vantassel@gmail.com>"

RUN apt update \
 && apt upgrade --yes \
 && apt install --yes --quiet --no-install-recommends \
   python3 \
   python3-pip \
 && apt clean

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

SHELL ["/bin/bash", "-ec"]

ADD requirements.txt /home/user/

RUN python3 -m pip install --upgrade pip==10 \
 && python3 -m pip install virtualenv \
 && python3 -m virtualenv /home/user/venv \ 
 && source /home/user/venv/bin/activate \
 && pip install -r /home/user/requirements.txt \
 && rm /home/user/requirements.txt \
 && mkdir /home/user/analysis/

ADD swbatch.py /home/user/

WORKDIR /home/user/

CMD ["python3", "/home/user/analysis/swbatch.py", "--help"]