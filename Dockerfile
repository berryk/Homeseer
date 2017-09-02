FROM debian:latest

ENV DEBIAN_FRONTEND noninteractive
ENV VERSION="3_0_0_326"
ENV TIMEZONE="America/New_York"

RUN apt-get update && apt-get install -y \
      wget \
      mono-vbnc \
      libmono-system-web4.0.cil \
      libmono-system-design4.0.cil \
      libmono-system-web-extensions4.0-cil \
      libmono-system-runtime-caching4.0-cil \
      flite \
      chromium \
      locales \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV LC_ALL="en_US.UTF-8"
ENV LANG="en_US.UTF-8"
ENV LANGUAGE="en_US.UTF-8"

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
    && locale-gen \
    && echo "$TIMEZONE" > /etc/timezone \
    && dpkg-reconfigure -f noninteractive tzdata

RUN wget -O tini.deb "https://github.com/krallin/tini/releases/download/v0.14.0/tini_0.14.0-amd64.deb" \
    && dpkg -i tini.deb \
    && rm tini.deb

#COPY ["Homeseer.zip", "/"]

RUN wget -O Homeseer.zip "https://www.dropbox.com/Oawt5vos5sayhpp/HomeSeer_hs_backup_DAILY_2017-09-02_03-00-00_FULL.zip?dl=1" \
 && unzip Homeseer.zip -d /Homeseer && rm Homeseer.zip

#RUN wget -O homeseer.tgz "http://homeseer.com/updates3/hs3_linux_${VERSION}.tar.gz" \
#    && tar -xzo -C / -f /homeseer.tgz \
#    && rm homeseer.tgz

COPY ["run.sh", "/"]

ENTRYPOINT ["tini", "--", "/run.sh"]
