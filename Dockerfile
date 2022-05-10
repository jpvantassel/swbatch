FROM jpvantassel/geopsy-docker:3.4.2-qt5.14

LABEL IMAGE_NAME="jpvantassel/swbatch:0.3.1"
LABEL IMAGE_NAME_ALT="jpvantassel/swbatch:geopsy-v3.4.2"
LABEL MAINTAINER="Joseph P. Vantassel <joseph.p.vantassel@gmail.com>"

RUN sudo apt update \
 && sudo apt upgrade --yes \
 && sudo apt install --yes --quiet --no-install-recommends \
   python3 \
   python3-pip \
 && sudo apt clean

ADD requirements.txt /home/user/

RUN pip3 install --user -r /home/user/requirements.txt && \
    rm requirements.txt

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

ADD swbatch.py /home/user/

WORKDIR /home/user/

CMD ["python3", "/home/user/swbatch.py", "--help"]
