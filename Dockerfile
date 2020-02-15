FROM ubuntu:trusty

ENV VERSION 18.0.2

ENV XULRUNNER_FILE xulrunner-${VERSION}.en-US.linux-x86_64.sdk.tar.bz2
ENV XULRUNNER_DL_LINK http://ftp.mozilla.org/pub/xulrunner/releases/${VERSION}/sdk/${XULRUNNER_FILE}

RUN apt-get update && apt-get install -y wget

RUN wget ${XULRUNNER_DL_LINK}
RUN tar -xjf ${XULRUNNER_FILE} -C /usr/bin
RUN rm ${XULRUNNER_FILE}

ENV PATH="/usr/bin/xulrunner-sdk/bin:${PATH}"
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/bin/xulrunner-sdk/bin:/usr/bin/xulrunner-sdk/lib"

RUN apt-get install -y make android-tools-adb udev usbutils zip libfreetype6 libfontconfig1 libxrender1 libxext6 libxdamage1 libxfixes3 libxcomposite1 libasound2 libdbus-glib-1-2 libgtk2.0-0 libxt6

WORKDIR /usr/src/kaios-app-installer
COPY install.js ./
COPY Makefile ./

ENTRYPOINT [ "make" ]