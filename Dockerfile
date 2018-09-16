FROM ubuntu:18.04

# Install basic tools
RUN apt-get -y update && \
    apt-get -y install curl wget unzip python-pip python-dev build-essential && \
    pip install --upgrade pip

# Install Chrome
RUN curl -sS -o - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add && \
    echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list && \
    apt-get -y update && \
    apt-get -y install google-chrome-stable

WORKDIR /tmp

# Install latest chrome driver
RUN wget -N "https://chromedriver.storage.googleapis.com/$(curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE)/chromedriver_linux64.zip" -P ./ && \
    unzip ./chromedriver_linux64.zip -d ./ && \
    rm ./chromedriver_linux64.zip && \
    mv -f ./chromedriver /usr/local/bin/chromedriver && \
    chown root:root /usr/local/bin/chromedriver && \
    chmod 0755 /usr/local/bin/chromedriver

WORKDIR /app

ADD ./requirements.txt /app/
RUN pip install -r ./requirements.txt

ADD ./download* /app/

CMD ["/app/download"]