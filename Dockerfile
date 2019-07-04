FROM node:12.1.0

# SET Encoding
ENV LANG C.UTF-8

# install Cypress OS dependencies
# but do not install recommended libs and clean temp files
#
# note:
#   Gtk2 for Cypress < 3.3.0
#   Gtk3 for Cypress >= 3.3.0

RUN apt-get update && \
  apt-get install --no-install-recommends -y \
  libgtk2.0-0 \
  libgtk-3-0 \
  libnotify-dev \
  libgconf-2-4 \
  libnss3 \
  libxss1 \
  libasound2 \
  libxtst6 \
  xauth \
  tzdata \
  xvfb \
  # install Chinese fonts
  fonts-arphic-bkai00mp \
  fonts-arphic-bsmi00lp \
  fonts-arphic-gbsn00lp \
  fonts-arphic-gkai00mp \
  fonts-arphic-ukai \
  fonts-arphic-uming \
  ttf-wqy-zenhei \
  ttf-wqy-microhei \
  xfonts-wqy \
  && rm -rf /var/lib/apt/lists/*

# SET Timezone
ENV TZ "Asia/Shanghai"
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
  && echo $TZ > /etc/TZ
  
# avoid too many progress messages
# https://github.com/cypress-io/cypress/issues/1243
ENV CI=1
ARG CYPRESS_VERSION="3.2.0"

RUN echo "whoami: $(whoami)"
RUN npm config -g set user $(whoami)
RUN npm install -g "cypress@${CYPRESS_VERSION}"
RUN cypress verify

# Cypress cache and installed version
RUN cypress cache path
RUN cypress cache list

# versions of local tools
RUN echo  " node version:    $(node -v) \n" \
  "npm version:     $(npm -v) \n" \
  "yarn version:    $(yarn -v) \n" \
  "debian version:  $(cat /etc/debian_version) \n" \
  "user:            $(whoami) \n"

ENTRYPOINT ["cypress", "run"]
